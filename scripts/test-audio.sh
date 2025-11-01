#!/bin/bash
# Claude Code Audio Hooks - Enhanced Audio Test Script v2.0
# Tests all audio files and provides diagnostics

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Directories
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
AUDIO_DIR="$PROJECT_DIR/audio/default"
HOOKS_DIR="$HOME/.claude/hooks"
CONFIG_FILE="$PROJECT_DIR/config/user_preferences.json"

echo -e "${BLUE}${BOLD}================================================${NC}"
echo -e "${BLUE}${BOLD}  Claude Code Audio Hooks - Audio Test v2.0${NC}"
echo -e "${BLUE}${BOLD}================================================${NC}\n"

#=============================================================================
# CHECK PREREQUISITES
#=============================================================================

echo -e "${CYAN}Checking prerequisites...${NC}\n"

# Check if shared library exists
if [ ! -f "$HOOKS_DIR/shared/hook_config.sh" ]; then
    echo -e "${RED}✗ Hook system not installed!${NC}"
    echo ""
    echo "Please run the installer first:"
    echo "  bash $PROJECT_DIR/scripts/install.sh"
    echo ""
    exit 1
fi

echo -e "${GREEN}✓${NC} Hook system is installed\n"

# Source the shared library for audio playback
source "$HOOKS_DIR/shared/hook_config.sh"

#=============================================================================
# LOAD CONFIGURATION
#=============================================================================

echo -e "${CYAN}Loading configuration...${NC}\n"

declare -A ENABLED_HOOKS

if [ -f "$CONFIG_FILE" ]; then
    # Load enabled hooks from config
    HOOKS=("notification" "stop" "pretooluse" "posttooluse" "userpromptsubmit" "subagent_stop" "precompact" "session_start" "session_end")

    for hook in "${HOOKS[@]}"; do
        enabled=$(python3 -c "import json; print(json.load(open('$CONFIG_FILE')).get('enabled_hooks', {}).get('$hook', False))" 2>/dev/null)
        ENABLED_HOOKS[$hook]=$([[ "$enabled" == "True" ]] && echo "true" || echo "false")
    done

    echo -e "${GREEN}✓${NC} Configuration loaded from user_preferences.json\n"
else
    # Use defaults
    ENABLED_HOOKS["notification"]="true"
    ENABLED_HOOKS["stop"]="true"
    ENABLED_HOOKS["pretooluse"]="false"
    ENABLED_HOOKS["posttooluse"]="false"
    ENABLED_HOOKS["userpromptsubmit"]="false"
    ENABLED_HOOKS["subagent_stop"]="true"
    ENABLED_HOOKS["precompact"]="false"
    ENABLED_HOOKS["session_start"]="false"
    ENABLED_HOOKS["session_end"]="false"

    echo -e "${YELLOW}⚠${NC} No config found, using defaults\n"
fi

#=============================================================================
# TEST OPTION
#=============================================================================

echo -e "${CYAN}${BOLD}What would you like to test?${NC}"
echo ""
echo -e "  ${BOLD}1.${NC} Test all enabled hooks (recommended)"
echo -e "  ${BOLD}2.${NC} Test ALL audio files (including disabled hooks)"
echo -e "  ${BOLD}3.${NC} Test specific hook"
echo -e "  ${BOLD}4.${NC} Quick test (task-complete audio only)"
echo ""
read -p "Enter option (1-4): " -n 1 -r TEST_OPTION
echo ""
echo ""

#=============================================================================
# AUDIO FILE DATA
#=============================================================================

declare -A AUDIO_FILES
declare -A AUDIO_DESCRIPTIONS

AUDIO_FILES["notification"]="notification-urgent.mp3"
AUDIO_FILES["stop"]="task-complete.mp3"
AUDIO_FILES["pretooluse"]="task-starting.mp3"
AUDIO_FILES["posttooluse"]="task-progress.mp3"
AUDIO_FILES["userpromptsubmit"]="prompt-received.mp3"
AUDIO_FILES["subagent_stop"]="subagent-complete.mp3"
AUDIO_FILES["precompact"]="notification-info.mp3"
AUDIO_FILES["session_start"]="session-start.mp3"
AUDIO_FILES["session_end"]="session-end.mp3"

AUDIO_DESCRIPTIONS["notification"]="Authorization/Confirmation Requests"
AUDIO_DESCRIPTIONS["stop"]="Task Completion"
AUDIO_DESCRIPTIONS["pretooluse"]="Before Tool Execution"
AUDIO_DESCRIPTIONS["posttooluse"]="After Tool Execution"
AUDIO_DESCRIPTIONS["userpromptsubmit"]="User Prompt Submission"
AUDIO_DESCRIPTIONS["subagent_stop"]="Subagent Task Completion"
AUDIO_DESCRIPTIONS["precompact"]="Before Conversation Compaction"
AUDIO_DESCRIPTIONS["session_start"]="Session Start"
AUDIO_DESCRIPTIONS["session_end"]="Session End"

#=============================================================================
# TEST FUNCTIONS
#=============================================================================

test_audio_file() {
    local hook=$1
    local audio_file="${AUDIO_FILES[$hook]}"
    local description="${AUDIO_DESCRIPTIONS[$hook]}"
    local full_path="$AUDIO_DIR/$audio_file"

    echo -e "${CYAN}Testing:${NC} ${BOLD}$description${NC}"
    echo -e "  Hook: $hook"
    echo -e "  File: $audio_file"

    if [ -f "$full_path" ]; then
        local size=$(du -h "$full_path" | cut -f1)
        echo -e "  Size: $size"

        echo -e "  ${BLUE}▶ Playing...${NC}"
        play_audio_internal "$full_path" 2>/dev/null

        sleep 3

        echo -e "  ${GREEN}✓${NC} Playback complete"
    else
        echo -e "  ${RED}✗${NC} File not found!"
    fi

    echo ""
}

#=============================================================================
# TEST EXECUTION
#=============================================================================

case $TEST_OPTION in
    1)
        # Test enabled hooks only
        echo -e "${BLUE}${BOLD}Testing Enabled Hooks${NC}\n"
        echo -e "This will test only the hooks you have enabled.\n"

        local tested=0
        for hook in notification stop pretooluse posttooluse userpromptsubmit subagent_stop precompact session_start session_end; do
            if [[ "${ENABLED_HOOKS[$hook]}" == "true" ]]; then
                test_audio_file "$hook"
                ((tested++))

                if [ $tested -lt 3 ]; then
                    echo -e "${CYAN}Next audio in 2 seconds...${NC}\n"
                    sleep 2
                fi
            fi
        done

        if [ $tested -eq 0 ]; then
            echo -e "${YELLOW}⚠${NC} No enabled hooks found!"
            echo "Run ./scripts/configure.sh to enable hooks."
        else
            echo -e "${GREEN}${BOLD}✓ Tested $tested enabled hook(s)${NC}"
        fi
        ;;

    2)
        # Test all audio files
        echo -e "${BLUE}${BOLD}Testing All Audio Files${NC}\n"
        echo -e "This will play all 9 audio files, including disabled hooks.\n"

        local count=0
        for hook in notification stop pretooluse posttooluse userpromptsubmit subagent_stop precompact session_start session_end; do
            test_audio_file "$hook"
            ((count++))

            if [ $count -lt 9 ]; then
                echo -e "${CYAN}Next audio in 2 seconds...${NC}\n"
                sleep 2
            fi
        done

        echo -e "${GREEN}${BOLD}✓ Tested all 9 audio files${NC}"
        ;;

    3)
        # Test specific hook
        echo -e "${BLUE}${BOLD}Test Specific Hook${NC}\n"
        echo "Select a hook to test:"
        echo ""
        echo "  1. Notification (authorization/confirmation)"
        echo "  2. Stop (task completion)"
        echo "  3. PreToolUse (before tool execution)"
        echo "  4. PostToolUse (after tool execution)"
        echo "  5. UserPromptSubmit (prompt submission)"
        echo "  6. SubagentStop (subagent completion)"
        echo "  7. PreCompact (before compaction)"
        echo "  8. SessionStart (session start)"
        echo "  9. SessionEnd (session end)"
        echo ""
        read -p "Enter number (1-9): " -n 1 -r HOOK_NUM
        echo ""
        echo ""

        case $HOOK_NUM in
            1) test_audio_file "notification" ;;
            2) test_audio_file "stop" ;;
            3) test_audio_file "pretooluse" ;;
            4) test_audio_file "posttooluse" ;;
            5) test_audio_file "userpromptsubmit" ;;
            6) test_audio_file "subagent_stop" ;;
            7) test_audio_file "precompact" ;;
            8) test_audio_file "session_start" ;;
            9) test_audio_file "session_end" ;;
            *) echo -e "${RED}Invalid selection${NC}" ;;
        esac
        ;;

    4)
        # Quick test
        echo -e "${BLUE}${BOLD}Quick Test${NC}\n"
        echo -e "Testing task-complete audio (most commonly used)...\n"

        test_audio_file "stop"

        echo -e "${GREEN}${BOLD}✓ Quick test complete${NC}"
        ;;

    *)
        echo -e "${RED}Invalid option${NC}"
        exit 1
        ;;
esac

#=============================================================================
# TROUBLESHOOTING
#=============================================================================

echo ""
echo -e "${CYAN}${BOLD}Did you hear the audio?${NC}\n"

read -p "Did all audio files play correctly? (y/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${YELLOW}${BOLD}Troubleshooting Tips:${NC}\n"

    echo -e "${BOLD}1. Check System Volume${NC}"
    echo "   • Make sure your system volume is not muted"
    echo "   • Try playing audio from another application"
    echo ""

    echo -e "${BOLD}2. Platform-Specific Issues${NC}"

    if grep -qi microsoft /proc/version 2>/dev/null; then
        echo "   • WSL detected: Ensure PowerShell is available"
        echo "   • Windows audio services should be running"
        echo "   • Try: powershell.exe -Command 'Get-Command Out-Host'"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "   • macOS: afplay should be available (built-in)"
        echo "   • Check System Preferences > Sound > Output"
    else
        echo "   • Linux: Install audio player:"
        echo "     sudo apt-get install mpg123"
        echo "   • Or: sudo apt-get install alsa-utils"
    fi
    echo ""

    echo -e "${BOLD}3. File Permissions${NC}"
    echo "   • Check audio files exist in: $AUDIO_DIR"
    echo "   • Run: ls -la $AUDIO_DIR"
    echo ""

    echo -e "${BOLD}4. Hook Configuration${NC}"
    echo "   • Run: ./scripts/check-setup.sh"
    echo "   • Verify all components are installed correctly"
    echo ""

    echo -e "${BOLD}5. Manual Test${NC}"
    echo "   • Try playing an audio file directly:"
    if grep -qi microsoft /proc/version 2>/dev/null; then
        echo "     powershell.exe -Command \"(New-Object Media.SoundPlayer '$AUDIO_DIR/task-complete.mp3').PlaySync()\""
    else
        echo "     mpg123 $AUDIO_DIR/task-complete.mp3"
    fi
    echo ""

    echo "For more help, see: docs/AUDIO_CREATION.md and README.md"
else
    echo ""
    echo -e "${GREEN}${BOLD}🎉 Great! Audio playback is working correctly!${NC}"
    echo ""
    echo "Your Claude Code Audio Hooks are ready to use."
    echo "You'll hear these notifications when using Claude Code!"
fi

echo ""
echo -e "${CYAN}${BOLD}📚 Additional Options:${NC}"
echo "  • Run ${BOLD}./scripts/configure.sh${NC} to enable/disable hooks"
echo "  • See ${BOLD}docs/AUDIO_CREATION.md${NC} to create custom audio"
echo "  • Run ${BOLD}./scripts/check-setup.sh${NC} for full system check"
echo ""
