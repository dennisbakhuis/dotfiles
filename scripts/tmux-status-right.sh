#!/usr/bin/env bash
# Right-hand tmux status segment: number of Claude sessions waiting for input
# across all windows (from @pane_status, written by claude-tmux-status.sh) and
# the host over SSH. Also clears marks left behind by a Claude that was killed
# without firing its SessionEnd hook (the pane is back at a plain shell).

tmux list-panes -a -F '#{pane_id} #{pane_current_command} #{@pane_status}' 2>/dev/null |
    while read -r pane cmd status; do
        [ -n "$status" ] || continue
        case "$cmd" in
            fish|bash|zsh|sh|dash)
                tmux set -pu -t "$pane" @pane_status
                tmux set -pu -t "$pane" @pane_wait_reason
                tmux set -pu -t "$pane" @pane_agent
                ;;
        esac
    done

waiting=$(tmux list-panes -a -F '#{@pane_status}' 2>/dev/null | grep -c '^waiting$')
if [ "$waiting" -gt 0 ]; then
    printf '#[fg=#e0af68,bold]\xef\x81\xb5 %s waiting #[default]' "$waiting"
fi

if [ -n "$SSH_CONNECTION" ] || tmux show-environment SSH_CONNECTION 2>/dev/null | grep -q '^SSH_CONNECTION='; then
    printf '#[fg=#9ece6a] %s@%s #[default]' "$(whoami)" "$(hostname -s)"
fi
