#!/bin/bash
# Test script to play audio for all enabled hooks
# This helps verify that different hooks play different audio files

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
AUDIO_DIR="$PROJECT_DIR/audio/default"

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  Testing Enabled Hooks Audio${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""
echo "This script will play audio for each ENABLED hook."
echo "Listen carefully to identify the differences!"
echo ""

# Function to play audio with announcement
play_audio_test() {
    local hook_name=$1
    local audio_file=$2
    local description=$3

    echo -e "${YELLOW}[$hook_name Hook]${NC}"
    echo "Description: $description"
    echo "Audio file: $(basename "$audio_file")"

    if [ ! -f "$audio_file" ]; then
        echo -e "${GREEN}✗${NC} Audio file not found!"
        echo ""
        return 1
    fi

    echo -e "${GREEN}▶${NC} Playing now..."

    # Play audio (WSL)
    if grep -qi microsoft /proc/version 2>/dev/null; then
        WIN_PATH=$(wslpath -w "$audio_file")
        powershell.exe -Command "
            Add-Type -AssemblyName presentationCore
            \$mediaPlayer = New-Object System.Windows.Media.MediaPlayer
            \$mediaPlayer.Open('$WIN_PATH')
            \$mediaPlayer.Play()
            Start-Sleep -Seconds 3
        " 2>/dev/null
    fi

    echo -e "${GREEN}✓${NC} Played!"
    echo ""
    echo "Waiting 5 seconds before next test..."
    echo ""
    sleep 5
}

# Test enabled hooks (based on default config)
echo -e "${BLUE}Testing ENABLED hooks (3 total):${NC}"
echo ""

# 1. Notification Hook
play_audio_test \
    "NOTIFICATION" \
    "$AUDIO_DIR/notification-urgent.mp3" \
    "Plays when Claude needs authorization or confirmation"

# 2. Stop Hook
play_audio_test \
    "STOP" \
    "$AUDIO_DIR/task-complete.mp3" \
    "Plays when Claude finishes responding"

# 3. SubagentStop Hook
play_audio_test \
    "SUBAGENT_STOP" \
    "$AUDIO_DIR/subagent-complete.mp3" \
    "Plays when background subagent tasks complete"

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  Test Complete!${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""
echo "Summary:"
echo "- notification-urgent.mp3: \"Attention! Claude needs your authorization.\""
echo "- task-complete.mp3: \"Task completed successfully.\""
echo "- subagent-complete.mp3: \"Subagent task completed.\""
echo ""
echo "If all three sounded the same, there may be an audio playback issue."
echo "If they sounded different, the hooks are working correctly!"
echo ""
