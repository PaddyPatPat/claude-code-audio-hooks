#!/bin/bash
# Claude Code SessionEnd Hook
# Plays audio when Claude Code session ends
# Optional: Nice "goodbye" sound when ending work

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/shared/hook_config.sh"

# Hook type and default audio file
get_and_play_audio "session_end" "session-end.mp3"
