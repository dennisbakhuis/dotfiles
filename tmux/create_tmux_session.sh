#!/bin/sh

# Initial session name to check
SESSION_NAME="main"

# List of alternative session names
SESSION_NAMES="session2 session3 session4 session5 session6 session7 session8"

# Function to check if a session exists and is attached
session_exists_and_attached() {
    tmux list-sessions | grep "^$1:" | grep -q "(attached)"
}

# Function to check if a session exists
session_exists() {
    tmux has-session -t "$1" 2>/dev/null
}

# Function to attach to or create a session
attach_or_create_session() {
    if session_exists "$1"; then
        if ! session_exists_and_attached "$1"; then
            # Session exists but is not attached, attach to it
            tmux attach-session -t "$1"
            exit 0
        else
            # Session exists and is attached, return 1
            return 1
        fi
    else
        # Session does not exist, create it
        tmux new-session -s "$1" -d
        tmux attach-session -t "$1"
        exit 0
    fi
}

# Try to attach or create the main session first
if ! attach_or_create_session "$SESSION_NAME"; then
    # If main session exists and is attached, try alternative names
    for name in $SESSION_NAMES; do
        if attach_or_create_session "$name"; then
            # Successfully attached or created a session, exit loop
            break
        fi
    done
fi

# If all names are taken and attached, print an error
echo "Error: All sessions are in use and attached. No available names to create a new session."
exit 1

