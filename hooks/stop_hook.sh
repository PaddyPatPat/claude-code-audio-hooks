#!/bin/bash
# Claude Code Stop Hook
# Plays audio when Claude finishes responding
# This is the original functionality from v1.0

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/shared/hook_config.sh"

# Hook type and default audio file
get_and_play_audio "stop" "task-complete.mp3"
