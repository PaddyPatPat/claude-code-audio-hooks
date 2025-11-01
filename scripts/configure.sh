#!/bin/bash
# Claude Code Audio Hooks - Interactive Configuration Tool
# Allows users to enable/disable hooks and customize settings

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

# Directories
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG_FILE="$PROJECT_DIR/config/user_preferences.json"
AUDIO_DIR="$PROJECT_DIR/audio"

# Source hook config for audio playback testing
source "$PROJECT_DIR/hooks/shared/hook_config.sh" 2>/dev/null || true

#=============================================================================
# CONFIGURATION STATE
#=============================================================================

declare -A HOOK_ENABLED
declare -A HOOK_AUDIO_FILES
declare -A HOOK_DESCRIPTIONS

# Initialize hook data
init_hooks() {
    # Hook descriptions
    HOOK_DESCRIPTIONS["notification"]="⚠️  Authorization/confirmation requests (CRITICAL)"
    HOOK_DESCRIPTIONS["stop"]="✅ Task completion"
    HOOK_DESCRIPTIONS["pretooluse"]="🔨 Before tool execution (can be noisy)"
    HOOK_DESCRIPTIONS["posttooluse"]="📊 After tool execution (very noisy)"
    HOOK_DESCRIPTIONS["userpromptsubmit"]="💬 User prompt submission"
    HOOK_DESCRIPTIONS["subagent_stop"]="🤖 Subagent task completion"
    HOOK_DESCRIPTIONS["precompact"]="🗜️  Before conversation compaction"
    HOOK_DESCRIPTIONS["session_start"]="👋 Session start"
    HOOK_DESCRIPTIONS["session_end"]="👋 Session end"

    # Load current configuration
    if [ -f "$CONFIG_FILE" ]; then
        load_configuration
    else
        # Use defaults
        HOOK_ENABLED["notification"]=true
        HOOK_ENABLED["stop"]=true
        HOOK_ENABLED["pretooluse"]=false
        HOOK_ENABLED["posttooluse"]=false
        HOOK_ENABLED["userpromptsubmit"]=false
        HOOK_ENABLED["subagent_stop"]=true
        HOOK_ENABLED["precompact"]=false
        HOOK_ENABLED["session_start"]=false
        HOOK_ENABLED["session_end"]=false
    fi
}

load_configuration() {
    local hooks=("notification" "stop" "pretooluse" "posttooluse" "userpromptsubmit" "subagent_stop" "precompact" "session_start" "session_end")

    for hook in "${hooks[@]}"; do
        local enabled=$(python3 -c "import json; config=json.load(open('$CONFIG_FILE')); print(str(config.get('enabled_hooks', {}).get('$hook', False)).lower())")
        HOOK_ENABLED["$hook"]=$([[ "$enabled" == "true" ]] && echo "true" || echo "false")
    done
}

save_configuration() {
    python3 << 'PYTHON_SCRIPT'
import json
import sys

config_file = sys.argv[1]

# Load existing config or create new
try:
    with open(config_file, 'r') as f:
        config = json.load(f)
except:
    config = {
        "version": "2.0.0",
        "playback_settings": {
            "queue_enabled": True,
            "max_queue_size": 5,
            "debounce_ms": 500
        }
    }

# Update enabled_hooks from environment variables
import os
enabled_hooks = {}
hooks = ["notification", "stop", "pretooluse", "posttooluse", "userpromptsubmit", "subagent_stop", "precompact", "session_start", "session_end"]

for hook in hooks:
    env_var = f"HOOK_{hook.upper()}"
    enabled_hooks[hook] = os.environ.get(env_var, "false") == "true"

config['enabled_hooks'] = enabled_hooks

# Save configuration
with open(config_file, 'w') as f:
    json.dump(config, f, indent=2)

print("Configuration saved successfully!")
PYTHON_SCRIPT

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} Configuration saved to $CONFIG_FILE"
        return 0
    else
        echo -e "${RED}✗${NC} Failed to save configuration"
        return 1
    fi
}

#=============================================================================
# UI FUNCTIONS
#=============================================================================

clear_screen() {
    clear
}

print_header() {
    clear_screen
    echo -e "${BLUE}${BOLD}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}${BOLD}║   Claude Code Audio Hooks Configuration       ║${NC}"
    echo -e "${BLUE}${BOLD}╚════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_hook_status() {
    local hook=$1
    local enabled=${HOOK_ENABLED[$hook]}

    if [[ "$enabled" == "true" ]]; then
        echo -e "${GREEN}[✓]${NC}"
    else
        echo -e "${RED}[ ]${NC}"
    fi
}

display_main_menu() {
    print_header

    echo -e "${CYAN}${BOLD}Current Configuration:${NC}\n"

    # Display all hooks with status
    local i=1
    for hook in notification stop pretooluse posttooluse userpromptsubmit subagent_stop precompact session_start session_end; do
        local status=$(print_hook_status "$hook")
        local desc="${HOOK_DESCRIPTIONS[$hook]}"
        printf "${BOLD}%d.${NC} %s ${desc}\n" $i "$status"
        ((i++))
    done

    echo ""
    echo -e "${CYAN}${BOLD}Options:${NC}"
    echo -e "  ${BOLD}[1-9]${NC} Toggle hook on/off"
    echo -e "  ${BOLD}[R]${NC}   Reset to recommended defaults"
    echo -e "  ${BOLD}[T]${NC}   Test audio files"
    echo -e "  ${BOLD}[S]${NC}   Save and exit"
    echo -e "  ${BOLD}[Q]${NC}   Quit without saving"
    echo ""
}

get_hook_by_number() {
    case $1 in
        1) echo "notification" ;;
        2) echo "stop" ;;
        3) echo "pretooluse" ;;
        4) echo "posttooluse" ;;
        5) echo "userpromptsubmit" ;;
        6) echo "subagent_stop" ;;
        7) echo "precompact" ;;
        8) echo "session_start" ;;
        9) echo "session_end" ;;
        *) echo "" ;;
    esac
}

toggle_hook() {
    local hook=$1

    if [[ "${HOOK_ENABLED[$hook]}" == "true" ]]; then
        HOOK_ENABLED[$hook]="false"
        echo -e "${YELLOW}Disabled${NC} $hook"
    else
        HOOK_ENABLED[$hook]="true"
        echo -e "${GREEN}Enabled${NC} $hook"
    fi

    sleep 0.5
}

reset_to_defaults() {
    print_header
    echo -e "${YELLOW}Reset to recommended defaults?${NC}\n"
    echo -e "Recommended configuration:"
    echo -e "  ${GREEN}✓${NC} Notification (authorization/confirmation)"
    echo -e "  ${GREEN}✓${NC} Stop (task completion)"
    echo -e "  ${GREEN}✓${NC} SubagentStop (background tasks)"
    echo -e "  ${RED}✗${NC} All others (disabled)"
    echo ""
    read -p "Confirm reset? (y/N): " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        HOOK_ENABLED["notification"]=true
        HOOK_ENABLED["stop"]=true
        HOOK_ENABLED["pretooluse"]=false
        HOOK_ENABLED["posttooluse"]=false
        HOOK_ENABLED["userpromptsubmit"]=false
        HOOK_ENABLED["subagent_stop"]=true
        HOOK_ENABLED["precompact"]=false
        HOOK_ENABLED["session_start"]=false
        HOOK_ENABLED["session_end"]=false

        echo -e "${GREEN}✓${NC} Reset to defaults"
        sleep 1
    fi
}

test_audio_files() {
    print_header
    echo -e "${CYAN}${BOLD}Audio File Testing${NC}\n"

    local hooks=("notification" "stop" "pretooluse" "posttooluse" "userpromptsubmit" "subagent_stop" "precompact" "session_start" "session_end")
    local audio_files=(
        "default/notification-urgent.mp3"
        "default/task-complete.mp3"
        "default/task-starting.mp3"
        "default/task-progress.mp3"
        "default/prompt-received.mp3"
        "default/subagent-complete.mp3"
        "default/notification-info.mp3"
        "default/session-start.mp3"
        "default/session-end.mp3"
    )

    echo -e "Testing enabled hooks only...\n"

    local tested=0
    for i in "${!hooks[@]}"; do
        local hook="${hooks[$i]}"
        local audio_file="$AUDIO_DIR/${audio_files[$i]}"

        if [[ "${HOOK_ENABLED[$hook]}" == "true" ]]; then
            if [ -f "$audio_file" ]; then
                echo -e "${CYAN}Playing:${NC} $hook (${audio_files[$i]})"
                play_audio_internal "$audio_file" 2>/dev/null
                sleep 3
                ((tested++))
            else
                echo -e "${YELLOW}⚠${NC} $hook: Audio file not found"
            fi
        fi
    done

    if [ $tested -eq 0 ]; then
        echo -e "${YELLOW}No enabled hooks to test!${NC}"
    else
        echo -e "\n${GREEN}✓${NC} Tested $tested audio file(s)"
    fi

    echo ""
    read -p "Press Enter to continue..."
}

#=============================================================================
# MAIN LOOP
#=============================================================================

main() {
    # Initialize
    init_hooks

    # Main loop
    while true; do
        display_main_menu

        read -p "Enter option: " -n 1 -r option
        echo ""

        case $option in
            [1-9])
                local hook=$(get_hook_by_number $option)
                if [ -n "$hook" ]; then
                    toggle_hook "$hook"
                fi
                ;;
            [Rr])
                reset_to_defaults
                ;;
            [Tt])
                test_audio_files
                ;;
            [Ss])
                print_header
                echo -e "${CYAN}Saving configuration...${NC}\n"

                # Export hook states as environment variables for Python script
                for hook in notification stop pretooluse posttooluse userpromptsubmit subagent_stop precompact session_start session_end; do
                    export HOOK_${hook^^}="${HOOK_ENABLED[$hook]}"
                done

                if save_configuration "$CONFIG_FILE"; then
                    echo ""
                    echo -e "${GREEN}${BOLD}Configuration saved successfully!${NC}"
                    echo -e "${YELLOW}${BOLD}Remember to restart Claude Code to apply changes.${NC}"
                    echo ""
                    exit 0
                else
                    echo -e "${RED}Failed to save configuration${NC}"
                    read -p "Press Enter to continue..."
                fi
                ;;
            [Qq])
                print_header
                echo -e "${YELLOW}Quit without saving?${NC}\n"
                read -p "Confirm (y/N): " -n 1 -r
                echo ""
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    echo -e "${CYAN}Configuration not saved. Exiting...${NC}"
                    exit 0
                fi
                ;;
            *)
                ;;
        esac
    done
}

# Check if configuration file directory exists
if [ ! -d "$(dirname "$CONFIG_FILE")" ]; then
    echo -e "${RED}Error: Configuration directory not found${NC}"
    echo -e "${YELLOW}Please run install.sh first${NC}"
    exit 1
fi

# Run main
main
