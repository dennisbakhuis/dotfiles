# GitHub Pull Request - Create a PR with AI-generated title and message
#
# Usage:
#   ghpr <destination_branch>
#
# Description:
#   Creates a GitHub pull request from the current branch to the specified
#   destination branch. Uses the llm CLI tool to generate a PR title and
#   body based on the git commit history.
#
# Requirements:
#   - gh (GitHub CLI)
#   - llm (LLM CLI tool with configured model)

function github_pull_request
    set -l dest_branch ""

    while test (count $argv) -gt 0
        switch $argv[1]
            case '-*'
                echo "Unknown option: $argv[1]"
                echo "Usage: github_pull_request <destination_branch>"
                return 1
            case '*'
                set dest_branch $argv[1]
                set -e argv[1]
        end
    end

    if test -z "$dest_branch"
        echo "Error: Destination branch name is required"
        echo "Usage: github_pull_request <destination_branch>"
        return 1
    end

    if not command -v gh &>/dev/null
        echo (set_color red)"Error: gh (GitHub CLI) is not installed"(set_color normal)
        echo "Install it with: brew install gh"
        return 1
    end

    if not command -v llm &>/dev/null
        echo (set_color red)"Error: llm CLI tool is not installed"(set_color normal)
        echo "Install it using the dotfiles installer or: brew install llm"
        return 1
    end

    if not git rev-parse --git-dir &>/dev/null
        echo (set_color red)"Error: Not in a git repository"(set_color normal)
        return 1
    end

    set -l current_branch (git branch --show-current 2>/dev/null)
    if test -z "$current_branch"
        echo (set_color red)"Error: Cannot determine current branch"(set_color normal)
        return 1
    end

    if test "$current_branch" = "$dest_branch"
        echo (set_color red)"Error: Already on destination branch: $dest_branch"(set_color normal)
        echo "Cannot create PR from a branch to itself"
        return 1
    end

    set -l dest_exists 0
    if git show-ref --verify --quiet refs/heads/$dest_branch
        set dest_exists 1
    else if git show-ref --verify --quiet refs/remotes/origin/$dest_branch
        set dest_exists 1
    else
        git fetch origin $dest_branch:$dest_branch &>/dev/null
        if test $status -eq 0
            set dest_exists 1
        end
    end

    if test $dest_exists -eq 0
        echo (set_color red)"Error: Destination branch '$dest_branch' does not exist"(set_color normal)
        echo "Available branches:"
        git branch -a | grep -v HEAD | sed 's/^..//;s/origin\///' | sort -u
        return 1
    end

    set -l commit_count (git rev-list --count origin/$dest_branch..HEAD 2>/dev/null)

    if test $status -ne 0
        set commit_count (git rev-list --count HEAD ^origin/$dest_branch 2>/dev/null)
    end

    if test -z "$commit_count" -o "$commit_count" = "0"
        echo (set_color yellow)"Warning: No commits to create PR from"(set_color normal)
        echo "Current branch '$current_branch' has no new commits compared to '$dest_branch'"
        return 1
    end

    echo (set_color cyan)"Found $commit_count commit(s) to include in PR"(set_color normal)

    set -l existing_pr (gh pr list --head $current_branch --base $dest_branch --json number --jq '.[0].number' 2>/dev/null)

    if test -n "$existing_pr"
        echo (set_color yellow)"Warning: A PR already exists for this branch (#$existing_pr)"(set_color normal)
        set -l pr_url (gh pr view $existing_pr --json url --jq '.url' 2>/dev/null)
        echo "View it at: $pr_url"

        echo (set_color cyan)"Do you want to continue and create another PR? [y/N]"(set_color normal)
        read -l confirm -P "> "

        if test "$confirm" != "y" -a "$confirm" != "Y"
            echo "Aborted"
            return 0
        end
    end

    if not git show-ref --verify --quiet refs/remotes/origin/$current_branch
        echo (set_color cyan)"Pushing current branch to origin..."(set_color normal)
        git push -u origin $current_branch

        if test $status -ne 0
            echo (set_color red)"✗ Failed to push branch to remote"(set_color normal)
            return 1
        end
        echo (set_color green)"✓ Branch pushed successfully"(set_color normal)
    else
        set -l local_commit (git rev-parse HEAD 2>/dev/null)
        set -l remote_commit (git rev-parse origin/$current_branch 2>/dev/null)

        if test "$local_commit" != "$remote_commit"
            echo (set_color cyan)"Pushing latest changes to origin..."(set_color normal)
            git push

            if test $status -ne 0
                echo (set_color red)"✗ Failed to push changes"(set_color normal)
                return 1
            end
            echo (set_color green)"✓ Changes pushed successfully"(set_color normal)
        end
    end

    echo (set_color cyan)"Gathering commit information..."(set_color normal)

    set -l commit_log (git log origin/$dest_branch..HEAD --format="%h - %s" 2>/dev/null)
    set -l commit_stats (git diff --stat origin/$dest_branch..HEAD 2>/dev/null)
    set -l files_changed (git diff --name-only origin/$dest_branch..HEAD 2>/dev/null | wc -l | string trim)

    echo (set_color cyan)"Generating PR title and description with AI..."(set_color normal)

    set -l llm_prompt "You are helping create a GitHub Pull Request. Based on the following git commit information, generate a concise PR title and detailed PR body.

COMMITS:
$commit_log

DIFF STATISTICS:
$commit_stats

FILES CHANGED: $files_changed

Generate a response in EXACTLY this format (do not include any other text or markdown):

TITLE: <one-line summary of changes, max 72 chars, no period at end>

BODY:
<detailed description following this structure:
- Brief overview of what changed and why
- Key changes or improvements (bullet points if multiple)
- Any breaking changes or important notes
- Testing considerations if relevant>

Keep the title concise and the body clear and professional. Focus on WHAT changed and WHY, not HOW (the code shows the HOW)."

    set -l llm_output (echo "$llm_prompt" | llm 2>&1)

    if test $status -ne 0
        echo (set_color red)"✗ Failed to generate PR content with LLM"(set_color normal)
        echo "Error: $llm_output"
        return 1
    end

    set -l pr_title ""
    set -l pr_body_text ""

    # Handle case where BODY: might be on the same line as title or separate
    if string match -qr "TITLE:\s*(.+?)\s+BODY:\s*(.*)" "$llm_output"
        # Title and body on same/adjacent lines
        set pr_title (echo "$llm_output" | string replace -rf '.*TITLE:\s*(.+?)\s+BODY:.*' '$1' | string trim)
        set pr_body_text (echo "$llm_output" | string replace -rf '.*BODY:\s*(.*)' '$1' | string trim)
    else if string match -q "*TITLE:*" "$llm_output"
        # Separate TITLE: and BODY: lines
        set -l in_body 0
        set -l body_lines
        for line in (echo "$llm_output" | string split \n)
            if string match -q "TITLE:*" $line
                set pr_title (string replace -r '^TITLE:\s*' '' $line | string trim)
            else if string match -q "BODY:*" $line
                set in_body 1
                # Check if body content is on same line as BODY:
                set -l body_start (string replace -r '^BODY:\s*' '' $line | string trim)
                if test -n "$body_start"
                    set -a body_lines "$body_start"
                end
            else if test $in_body -eq 1
                set -a body_lines "$line"
            end
        end
        # Join with actual newlines
        set pr_body_text (string join \n $body_lines)
    end

    if test -z "$pr_title"
        echo (set_color red)"✗ Failed to parse PR title from LLM output"(set_color normal)
        echo "LLM output was:"
        echo "$llm_output"
        return 1
    end

    if test -z "$pr_body_text"
        set pr_body_text "No description provided"
    end

    echo ""
    echo (set_color cyan)"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"(set_color normal)
    echo (set_color green)"Generated PR Title:"(set_color normal)
    echo "$pr_title"
    echo ""
    echo (set_color green)"Generated PR Body:"(set_color normal)
    echo -e "$pr_body_text"
    echo (set_color cyan)"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"(set_color normal)
    echo ""

    echo (set_color yellow)"Create PR with this title and description? [y/N]"(set_color normal)
    read -l confirm -P "> "

    if test "$confirm" != "y" -a "$confirm" != "Y"
        echo "PR creation aborted"
        return 0
    end

    echo (set_color cyan)"Creating pull request..."(set_color normal)

    set -l pr_url (echo -e "$pr_body_text" | gh pr create \
        --base "$dest_branch" \
        --head "$current_branch" \
        --title "$pr_title" \
        --body-file - \
        2>&1)

    if test $status -ne 0
        echo (set_color red)"✗ Failed to create pull request"(set_color normal)
        echo "Error: $pr_url"
        return 1
    end

    echo (set_color green)"✓ Pull request created successfully!"(set_color normal)
    echo ""
    echo (set_color cyan)"PR URL:"(set_color normal)
    echo "$pr_url"
end
