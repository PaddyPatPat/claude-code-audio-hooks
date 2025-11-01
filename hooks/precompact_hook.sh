#!/bin/bash
# Claude Code PreCompact Hook
# Plays audio before conversation history compaction
# Rare event - mostly for debugging purposes

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/shared/hook_config.sh"

# Hook type and default audio file
get_and_play_audio "precompact" "notification-info.mp3"
