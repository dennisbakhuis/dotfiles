#!/usr/bin/env bash
# Set the tmux option @fullscreen to 1 when the macOS menu bar (and with it
# the system clock) is hidden, which is the case in native full screen, else
# 0. The status bar shows its own clock only then. Run from tmux hooks on
# client resize/attach, so there is no polling.
#
# Detected without extra permissions: the menu bar is an on-screen window of
# the Window Server at the main-menu level (24); in full screen it is gone.

full=0
if [ "$(uname -s)" = "Darwin" ] && command -v osascript >/dev/null 2>&1; then
    full=$(osascript -l JavaScript 2>/dev/null <<'JXA'
ObjC.import('CoreGraphics');
const wins = ObjC.deepUnwrap(ObjC.castRefToObject(
    $.CGWindowListCopyWindowInfo($.kCGWindowListOptionOnScreenOnly, $.kCGNullWindowID)));
const menubar = wins.some(w => w.kCGWindowOwnerName === 'Window Server' && w.kCGWindowLayer === 24);
menubar ? 0 : 1;
JXA
)
fi
tmux set -g @fullscreen "${full:-0}" 2>/dev/null
tmux refresh-client -S 2>/dev/null
exit 0
