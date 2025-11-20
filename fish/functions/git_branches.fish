# Git Branches - Display all branches with merge status information
#
# Shows local and remote branches sorted by commit date. For regular branches,
# displays which branches they've been merged into and when. For main/master
# branches, shows the most recently merged branch.

function git_branches
    set -l main_branch (git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "master")

    set -l all_branches (git branch -a --format='%(refname:short)' | string trim)
    set -l local_branches (git branch --format='%(refname:short)' | string trim)

    echo (set_color cyan)"Local branches:"(set_color normal)
    git branch --sort=-committerdate | while read -l line
        set -l branch (echo $line | string trim | string replace '* ' '')
        set -l is_current (string match -r '^\*' $line)

        if test "$branch" = "$main_branch" -o "$branch" = "main" -o "$branch" = "master"
            set -l last_merged
            for other_branch in $local_branches
                if test "$other_branch" = "$branch"
                    continue
                end
                if git merge-base --is-ancestor $other_branch $branch 2>/dev/null
                    set -l merge_base (git merge-base $other_branch $branch 2>/dev/null)
                    set -l other_commit (git rev-parse $other_branch 2>/dev/null)
                    set -l branch_commit (git rev-parse $branch 2>/dev/null)
                    if test "$merge_base" = "$other_commit" -a "$other_commit" != "$branch_commit"
                        set last_merged $other_branch
                        break
                    end
                end
            end

            if test -n "$last_merged"
                if test -n "$is_current"
                    echo (set_color yellow)"$line"(set_color normal) (set_color blue)"← last merge: $last_merged"(set_color normal)
                else
                    echo "$line" (set_color blue)"← last merge: $last_merged"(set_color normal)
                end
            else
                if test -n "$is_current"
                    echo (set_color yellow)"$line"(set_color normal)
                else
                    echo "$line"
                end
            end
        else
            set -l merged_into
            for target in $all_branches
                if test "$branch" = "$target"
                    continue
                end
                if string match -q "origin/$branch" $target
                    continue
                end
                if string match -q "*/HEAD*" $target
                    continue
                end

                if git merge-base --is-ancestor $branch $target 2>/dev/null
                    set -l merge_base (git merge-base $branch $target 2>/dev/null)
                    set -l branch_commit (git rev-parse $branch 2>/dev/null)
                    set -l target_commit (git rev-parse $target 2>/dev/null)
                    if test "$merge_base" = "$branch_commit" -a "$branch_commit" != "$target_commit"
                        set merged_into $merged_into $target
                    end
                end
            end

            if test (count $merged_into) -gt 0
                set -l merge_date (git log --merges --first-parent $merged_into[1] --format="%ci" --grep="Merge.*$branch" -1 2>/dev/null)
                if test -z "$merge_date"
                    set merge_date (git log -1 --format="%ci" $branch 2>/dev/null)
                end
                set -l formatted_date (date -j -f "%Y-%m-%d %H:%M:%S %z" "$merge_date" "+%Y-%m-%d %H:%M" 2>/dev/null || echo "")

                if test -n "$is_current"
                    echo (set_color yellow)"$line"(set_color normal) (set_color green)"✓ (merged to $merged_into[1] on $formatted_date)"(set_color normal)
                else
                    echo "$line" (set_color green)"✓ (merged to $merged_into[1] on $formatted_date)"(set_color normal)
                end
            else
                if test -n "$is_current"
                    echo (set_color yellow)"$line"(set_color normal)
                else
                    echo "$line"
                end
            end
        end
    end

    echo ""
    echo (set_color cyan)"Remote branches:"(set_color normal)
    git branch -r --sort=-committerdate | string match -v '*/HEAD*'
end
