#!/usr/bin/env bash
# Claude Code hook: record this session's state on its tmux pane so the tmux
# status bar can show a mark per window (see @agent_glyphs in tmux/tmux.conf).
#
# Usage (from claude/settings.json hooks): claude-tmux-status.sh <event>
#   start | prompt | tool  -> idle / running
#   notify                 -> waiting (reason read from the hook JSON on stdin)
#   stop                   -> idle if you are looking at the window, else done
#   seen                   -> turn "done" into idle for the windows on screen
#                             (called by tmux hooks on window switch / focus)
#   error                  -> error
#   end                    -> clear
#
# Other agents reuse this script by setting TMUX_AGENT (the opencode plugin in
# opencode/plugins/tmux-status sets TMUX_AGENT=opencode); tmux puts a dim "o" in
# front of the mark of any pane whose @pane_agent is opencode.
#
# Pane options written: @pane_status, @pane_wait_reason, @pane_agent.
# Always exits 0 so a tmux hiccup can never block Claude.

command -v tmux >/dev/null 2>&1 || exit 0

if [ "$1" = "seen" ]; then
    tmux list-panes -a -F '#{pane_id} #{window_active} #{session_attached} #{@pane_status}' 2>/dev/null |
        while read -r pane active attached status; do
            if [ "$status" = "done" ] && [ "$active" = "1" ] && [ "$attached" != "0" ]; then
                tmux set -p -t "$pane" @pane_status idle
            fi
        done
    tmux refresh-client -S 2>/dev/null
    exit 0
fi

[ -n "$TMUX_PANE" ] || exit 0

# True when the pane's window is on screen in a focused terminal. Terminals
# that do not report focus count as focused, so the mark never gets stuck.
being_watched() {
    local info active session
    info=$(tmux display -p -t "$TMUX_PANE" '#{window_active} #{session_name}' 2>/dev/null) || return 1
    active=${info%% *}; session=${info#* }
    [ "$active" = "1" ] || return 1
    local clients
    clients=$(tmux list-clients -t "$session" -F '#{client_flags}' 2>/dev/null)
    [ -n "$clients" ] || return 1
    if tmux list-clients -F '#{client_flags}' 2>/dev/null | grep -q focused; then
        printf '%s\n' "$clients" | grep -q focused
    else
        return 0
    fi
}

set_state() {
    tmux set -p -t "$TMUX_PANE" @pane_status "$1" 2>/dev/null
    tmux set -p -t "$TMUX_PANE" @pane_agent "${TMUX_AGENT:-claude}" 2>/dev/null
    if [ -n "$2" ]; then
        tmux set -p -t "$TMUX_PANE" @pane_wait_reason "$2" 2>/dev/null
    else
        tmux set -pu -t "$TMUX_PANE" @pane_wait_reason 2>/dev/null
    fi
}

case "$1" in
    start)       set_state idle ;;
    stop)        if being_watched; then set_state idle; else set_state "done"; fi ;;
    prompt|tool) set_state running ;;
    error)       set_state error ;;
    notify)
        reason=$(sed -n 's/.*"notification_type"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1)
        # idle_prompt only means "still waiting for your next message"
        [ "$reason" = "idle_prompt" ] && exit 0
        set_state waiting "$reason"
        ;;
    end)
        tmux set -pu -t "$TMUX_PANE" @pane_status 2>/dev/null
        tmux set -pu -t "$TMUX_PANE" @pane_wait_reason 2>/dev/null
        tmux set -pu -t "$TMUX_PANE" @pane_agent 2>/dev/null
        ;;
esac

tmux refresh-client -S 2>/dev/null
exit 0
