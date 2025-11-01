#!/bin/bash
# Claude Code PreToolUse Hook
# Plays audio before Claude executes any tool
# WARNING: Can be very noisy if enabled - use sparingly!

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/shared/hook_config.sh"

# Hook type and default audio file
get_and_play_audio "pretooluse" "task-starting.mp3"
