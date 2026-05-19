#!/usr/bin/env bash
# Print a git-aware folder name for status displays.
# Used by claude/statusline.sh and tmux/tmux.conf so both pick the same name.
#
# Usage: folder-name.sh [--short|--full] [path]   (defaults: --short, $PWD)
#
# --short (tmux window names):
#   in git repo  -> repo basename
#   $HOME        -> "~"
#   otherwise    -> directory basename
#
# --full (statusline; subpath included):
#   in git repo  -> repo-name/sub/path
#   $HOME subdir -> ~/sub/path
#   otherwise    -> absolute path
#
# Exit 0 inside a git repo, 1 outside — lets callers pick a glyph.

mode="short"
case "$1" in
  --full)  mode="full";  shift ;;
  --short) mode="short"; shift ;;
esac
cwd="${1:-$PWD}"
[ -z "$cwd" ] && cwd="$PWD"

repo_root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)
if [ -n "$repo_root" ]; then
  repo_name=$(basename "$repo_root")
  if [ "$mode" = "full" ] && [ "$cwd" != "$repo_root" ]; then
    echo "${repo_name}/${cwd#$repo_root/}"
  else
    echo "$repo_name"
  fi
  exit 0
fi

if [ "$cwd" = "$HOME" ]; then
  echo "~"
elif [ "${cwd#$HOME/}" != "$cwd" ]; then
  if [ "$mode" = "full" ]; then
    echo "~/${cwd#$HOME/}"
  else
    basename "$cwd"
  fi
elif [ "$mode" = "full" ]; then
  echo "$cwd"
else
  basename "$cwd"
fi
exit 1
