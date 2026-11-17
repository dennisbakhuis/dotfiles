#!/usr/bin/env bash
# Right-hand tmux status segment: number of agents waiting for input across
# all windows (from tmux-agent-sidebar's @pane_status) and the host over SSH.

waiting=$(tmux list-panes -a -F '#{@pane_status}' 2>/dev/null | grep -c -E '^(waiting|notification)$')
if [ "$waiting" -gt 0 ]; then
    printf '#[fg=#e0af68,bold]◐ %s waiting #[default]' "$waiting"
fi

if [ -n "$SSH_CONNECTION" ] || tmux show-environment SSH_CONNECTION 2>/dev/null | grep -q '^SSH_CONNECTION='; then
    printf '#[fg=#9ece6a] %s@%s #[default]' "$(whoami)" "$(hostname -s)"
fi
