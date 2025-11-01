#!/bin/bash
# Claude Code Notification Hook
# Plays audio when Claude sends a notification (authorization/confirmation requests)
# This is triggered when Claude needs user input or permission

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/shared/hook_config.sh"

# Hook type and default audio file
get_and_play_audio "notification" "notification-urgent.mp3"
