#!/bin/bash
# Claude Code UserPromptSubmit Hook
# Plays audio when user submits a prompt
# Optional: Provides confirmation that your input was received

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/shared/hook_config.sh"

# Hook type and default audio file
get_and_play_audio "userpromptsubmit" "prompt-received.mp3"
