#!/bin/bash
# Claude Code PostToolUse Hook
# Plays audio after Claude completes a tool execution
# WARNING: Very noisy - recommended only for debugging!

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/shared/hook_config.sh"

# Hook type and default audio file
get_and_play_audio "posttooluse" "task-progress.mp3"
