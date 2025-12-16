# Git Branch Switch - Switch to a branch or create it if it doesn't exist
#
# Usage:
#   gbs <branch_name>           # Switch to branch, create if doesn't exist
#   gbs -b <branch_name>        # Force create new branch (even if exists)
#
# Flags:
#   -b, --new       Force create a new branch
#
# Behavior:
#   - If branch exists locally: switch to it
#   - If branch exists remotely: checkout and track it
#   - If branch doesn't exist: create it locally and push to remote with tracking

function git_branch_switch
    set -l force_new 0
    set -l branch_name ""

    while test (count $argv) -gt 0
        switch $argv[1]
            case -b --new
                set force_new 1
                set -e argv[1]
            case '-*'
                echo "Unknown option: $argv[1]"
                echo "Usage: gbs [-b|--new] <branch_name>"
                return 1
            case '*'
                set branch_name $argv[1]
                set -e argv[1]
        end
    end

    if test -z "$branch_name"
        echo "Error: Branch name is required"
        echo "Usage: gbs [-b|--new] <branch_name>"
        return 1
    end

    set -l current_branch (git branch --show-current 2>/dev/null)
    if test "$branch_name" = "$current_branch" -a $force_new -eq 0
        echo (set_color yellow)"Already on branch: $branch_name"(set_color normal)
        return 0
    end

    set -l has_remote (git remote get-url origin &>/dev/null; echo $status)
    set -l local_exists (git show-ref --verify --quiet refs/heads/$branch_name; echo $status)
    set -l remote_tracking_exists (git show-ref --verify --quiet refs/remotes/origin/$branch_name; echo $status)

    if test $force_new -eq 1
        echo (set_color cyan)"Creating new branch: $branch_name"(set_color normal)
        git switch -c $branch_name --quiet
        if test $status -ne 0
            echo (set_color red)"✗ Failed to create branch"(set_color normal)
            return 1
        end
        echo (set_color green)"✓ Branch created and switched"(set_color normal)

        if test $has_remote -eq 0
            echo (set_color cyan)"Pushing to remote and setting up tracking..."(set_color normal)
            git push -u origin $branch_name
            if test $status -eq 0
                echo (set_color green)"✓ Branch pushed to remote with tracking"(set_color normal)
            else
                echo (set_color yellow)"⚠ Branch created locally but failed to push to remote"(set_color normal)
            end
        end

    else if test $local_exists -eq 0
        echo (set_color cyan)"Switching to existing local branch: $branch_name"(set_color normal)

        if test $has_remote -eq 0
            git fetch origin $branch_name:refs/remotes/origin/$branch_name --quiet 2>/dev/null
        end

        git switch $branch_name --quiet
        if test $status -eq 0
            echo (set_color green)"✓ Switched to branch: $branch_name"(set_color normal)
        else
            echo (set_color red)"✗ Failed to switch to branch"(set_color normal)
            return 1
        end

    else if test $remote_tracking_exists -eq 0
        echo (set_color cyan)"Switching to remote branch: origin/$branch_name"(set_color normal)
        git switch -c $branch_name --track origin/$branch_name --quiet
        if test $status -eq 0
            echo (set_color green)"✓ Switched and tracking remote branch"(set_color normal)
        else
            echo (set_color red)"✗ Failed to switch to remote branch"(set_color normal)
            return 1
        end

    else
        echo (set_color cyan)"Creating new branch: $branch_name"(set_color normal)
        git switch -c $branch_name --quiet
        if test $status -ne 0
            echo (set_color red)"✗ Failed to create branch"(set_color normal)
            return 1
        end
        echo (set_color green)"✓ Branch created and switched"(set_color normal)

        if test $has_remote -eq 0
            echo (set_color cyan)"Pushing to remote and setting up tracking..."(set_color normal)
            git push -u origin $branch_name
            if test $status -eq 0
                echo (set_color green)"✓ Branch pushed to remote with tracking"(set_color normal)
            else
                echo (set_color yellow)"⚠ Branch created locally but failed to push to remote"(set_color normal)
            end
        end
    end
end
