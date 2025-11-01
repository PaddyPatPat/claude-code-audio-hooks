#!/bin/bash
# Claude Code SessionStart Hook
# Plays audio when Claude Code session starts or resumes
# Optional: Nice "hello" greeting when starting work

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/shared/hook_config.sh"

# Hook type and default audio file
get_and_play_audio "session_start" "session-start.mp3"
