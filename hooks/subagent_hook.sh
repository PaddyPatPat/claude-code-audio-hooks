#!/bin/bash
# Claude Code SubagentStop Hook
# Plays audio when a subagent task completes
# Useful for tracking background operations

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/shared/hook_config.sh"

# Hook type and default audio file
get_and_play_audio "subagent_stop" "subagent-complete.mp3"
