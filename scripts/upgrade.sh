#!/bin/bash
# Claude Code Audio Hooks - Standalone Upgrade Script
# Upgrades v1.0 installation to v2.0 with multi-hook support

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Version info
OLD_VERSION="1.0.0"
NEW_VERSION="2.0.0"

# Directories
HOME_DIR="$HOME"
CLAUDE_DIR="$HOME_DIR/.claude"
HOOKS_DIR="$CLAUDE_DIR/hooks"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
SETTINGS_LOCAL_FILE="$CLAUDE_DIR/settings.local.json"
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo -e "${BLUE}${BOLD}================================================${NC}"
echo -e "${BLUE}${BOLD}  Claude Code Audio Hooks${NC}"
echo -e "${BLUE}${BOLD}  Upgrade: v${OLD_VERSION} → v${NEW_VERSION}${NC}"
echo -e "${BLUE}${BOLD}================================================${NC}\n"

#=============================================================================
# DETECTION
#=============================================================================

detect_v1() {
    if [ -f "$HOOKS_DIR/play_audio.sh" ]; then
        if ! grep -q "hook_config.sh" "$HOOKS_DIR/play_audio.sh" 2>/dev/null; then
            return 0  # v1.0 detected
        fi
    fi
    return 1
}

if ! detect_v1; then
    echo -e "${YELLOW}${BOLD}No v1.0 installation detected.${NC}\n"
    echo -e "${CYAN}You may already be on v2.0, or no installation found.${NC}"
    echo -e "${CYAN}Run 'bash scripts/install.sh' for fresh installation.${NC}\n"
    exit 0
fi

echo -e "${GREEN}✓${NC} v1.0 installation detected\n"

#=============================================================================
# BACKUP
#=============================================================================

echo -e "${BLUE}${BOLD}Creating backups...${NC}\n"

BACKUP_DIR="$HOME/.claude/backups/audio-hooks-v1-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup old hook script
if [ -f "$HOOKS_DIR/play_audio.sh" ]; then
    cp "$HOOKS_DIR/play_audio.sh" "$BACKUP_DIR/"
    echo -e "${GREEN}✓${NC} Backed up play_audio.sh"
fi

# Backup settings
if [ -f "$SETTINGS_FILE" ]; then
    cp "$SETTINGS_FILE" "$BACKUP_DIR/settings.json.backup"
    echo -e "${GREEN}✓${NC} Backed up settings.json"
fi

if [ -f "$SETTINGS_LOCAL_FILE" ]; then
    cp "$SETTINGS_LOCAL_FILE" "$BACKUP_DIR/settings.local.json.backup"
    echo -e "${GREEN}✓${NC} Backed up settings.local.json"
fi

echo -e "${CYAN}Backups saved to: $BACKUP_DIR${NC}\n"

#=============================================================================
# PRESERVE USER CUSTOMIZATION
#=============================================================================

echo -e "${BLUE}${BOLD}Preserving user customizations...${NC}\n"

# Check if user has custom audio file
CUSTOM_AUDIO=""
if [ -f "$PROJECT_DIR/audio/hey-chan-please-help-me.mp3" ]; then
    # Compare with original to see if it's custom
    ORIGINAL_SIZE=25600  # Approximate original file size
    CURRENT_SIZE=$(stat -f%z "$PROJECT_DIR/audio/hey-chan-please-help-me.mp3" 2>/dev/null || stat -c%s "$PROJECT_DIR/audio/hey-chan-please-help-me.mp3" 2>/dev/null || echo "0")

    if [ "$CURRENT_SIZE" -ne "$ORIGINAL_SIZE" ]; then
        CUSTOM_AUDIO="$PROJECT_DIR/audio/hey-chan-please-help-me.mp3"
        echo -e "${CYAN}ℹ${NC} Custom audio file detected, will preserve it"
    fi
fi

echo -e "${GREEN}✓${NC} User customizations preserved\n"

#=============================================================================
# CLEAN OLD INSTALLATION
#=============================================================================

echo -e "${BLUE}${BOLD}Removing old v1.0 components...${NC}\n"

# Remove old hook script from ~/.claude/hooks/
if [ -f "$HOOKS_DIR/play_audio.sh" ]; then
    rm "$HOOKS_DIR/play_audio.sh"
    echo -e "${GREEN}✓${NC} Removed old hook script"
fi

# Remove old hook configuration from settings.json
python3 << 'PYTHON_SCRIPT'
import json
import os

settings_file = os.path.expanduser("~/.claude/settings.json")
if os.path.exists(settings_file):
    with open(settings_file, 'r') as f:
        settings = json.load(f)

    # Remove old Stop hook if it points to old play_audio.sh
    if 'hooks' in settings and 'Stop' in settings['hooks']:
        old_hooks = settings['hooks']['Stop']
        settings['hooks']['Stop'] = [
            hook for hook in old_hooks
            if not any(
                h.get('command', '').endswith('play_audio.sh')
                for h in hook.get('hooks', [])
            )
        ]

    with open(settings_file, 'w') as f:
        json.dump(settings, f, indent=2)

    print("✓ Cleaned old hook configuration from settings.json")
PYTHON_SCRIPT

# Remove old permission
python3 << 'PYTHON_SCRIPT'
import json
import os

settings_local_file = os.path.expanduser("~/.claude/settings.local.json")
if os.path.exists(settings_local_file):
    with open(settings_local_file, 'r') as f:
        settings = json.load(f)

    # Remove old permission
    if 'permissions' in settings and 'allow' in settings['permissions']:
        settings['permissions']['allow'] = [
            perm for perm in settings['permissions']['allow']
            if 'play_audio.sh' not in perm or 'notification_hook.sh' in perm or 'stop_hook.sh' in perm
        ]

    with open(settings_local_file, 'w') as f:
        json.dump(settings, f, indent=2)

    print("✓ Cleaned old permissions from settings.local.json")
PYTHON_SCRIPT

echo ""

#=============================================================================
# INSTALL V2.0
#=============================================================================

echo -e "${BLUE}${BOLD}Installing v2.0...${NC}\n"
echo -e "${CYAN}Running install.sh...${NC}\n"

# Run the main installer
cd "$PROJECT_DIR"
bash scripts/install.sh

#=============================================================================
# POST-UPGRADE CUSTOMIZATION
#=============================================================================

echo -e "\n${BLUE}${BOLD}Post-upgrade customization...${NC}\n"

# If user had custom audio, copy it to new location
if [ -n "$CUSTOM_AUDIO" ]; then
    cp "$CUSTOM_AUDIO" "$PROJECT_DIR/audio/default/task-complete.mp3"
    echo -e "${GREEN}✓${NC} Your custom audio file has been preserved as task-complete.mp3"
fi

#=============================================================================
# SUMMARY
#=============================================================================

echo -e "\n${GREEN}${BOLD}================================================${NC}"
echo -e "${GREEN}${BOLD}  Upgrade Complete! 🎉${NC}"
echo -e "${GREEN}${BOLD}================================================${NC}\n"

echo -e "${CYAN}${BOLD}📝 Upgrade Summary:${NC}"
echo -e "   ${BOLD}From:${NC} v${OLD_VERSION} (single Stop hook)"
echo -e "   ${BOLD}To:${NC} v${NEW_VERSION} (9 hook types)"
echo -e "   ${BOLD}Backups:${NC} $BACKUP_DIR"
echo ""

echo -e "${CYAN}${BOLD}🆕 What's New in v2.0:${NC}"
echo -e "   ${GREEN}✓${NC} ${BOLD}Notification Hook${NC} - Authorization/confirmation alerts"
echo -e "   ${GREEN}✓${NC} ${BOLD}SubagentStop Hook${NC} - Background task completion"
echo -e "   ${GREEN}✓${NC} ${BOLD}PreToolUse Hook${NC} - Before tool execution alerts"
echo -e "   ${GREEN}✓${NC} ${BOLD}PostToolUse Hook${NC} - After tool execution alerts"
echo -e "   ${GREEN}✓${NC} ${BOLD}Session Hooks${NC} - Start/end notifications"
echo -e "   ${GREEN}✓${NC} ${BOLD}User Prompt Hook${NC} - Prompt submission confirmation"
echo -e "   ${GREEN}✓${NC} ${BOLD}PreCompact Hook${NC} - Before conversation compaction"
echo -e "   ${GREEN}✓${NC} Configurable via ${BOLD}config/user_preferences.json${NC}"
echo -e "   ${GREEN}✓${NC} Audio queue system prevents overlapping sounds"
echo -e "   ${GREEN}✓${NC} Debounce system prevents notification spam"
echo ""

echo -e "${CYAN}${BOLD}📚 Important Changes:${NC}"
echo -e "   • Audio files now in ${BOLD}audio/default/${NC} directory"
echo -e "   • Your old audio preserved in ${BOLD}audio/legacy/${NC}"
echo -e "   • Configuration in ${BOLD}config/user_preferences.json${NC}"
echo -e "   • Multiple hook scripts in ${BOLD}~/.claude/hooks/${NC}"
echo ""

echo -e "${CYAN}${BOLD}🎵 Currently Enabled:${NC}"
echo -e "   ✓ ${GREEN}Notification${NC} (NEW!) - For authorization requests"
echo -e "   ✓ ${GREEN}Stop${NC} (Existing) - For task completion"
echo -e "   ✓ ${GREEN}SubagentStop${NC} (NEW!) - For background tasks"
echo ""

echo -e "${CYAN}${BOLD}📚 Next Steps:${NC}"
echo -e "   ${BOLD}1.${NC} ${YELLOW}IMPORTANT: Restart Claude Code${NC}"
echo -e "   ${BOLD}2.${NC} Test: You'll now hear alerts for authorization requests!"
echo -e "   ${BOLD}3.${NC} Run ${BOLD}bash scripts/configure.sh${NC} to customize hooks"
echo -e "   ${BOLD}4.${NC} Run ${BOLD}bash scripts/test-audio.sh${NC} to test all sounds"
echo -e "   ${BOLD}5.${NC} See ${BOLD}docs/AUDIO_CREATION.md${NC} to create custom audio"
echo ""

echo -e "${YELLOW}${BOLD}⚠️  Important:${NC}"
echo -e "   • Some audio files are currently placeholders (all the same)"
echo -e "   • Replace them with custom audio for best experience"
echo -e "   • See ${BOLD}audio/README.md${NC} for instructions"
echo ""

echo -e "${CYAN}${BOLD}🔄 Rollback (if needed):${NC}"
echo -e "   If you want to go back to v1.0:"
echo -e "   ${BOLD}1.${NC} bash scripts/uninstall.sh"
echo -e "   ${BOLD}2.${NC} cp $BACKUP_DIR/play_audio.sh ~/.claude/hooks/"
echo -e "   ${BOLD}3.${NC} Manually restore settings from backup directory"
echo ""

echo -e "${GREEN}${BOLD}Enjoy your enhanced notification system! 🚀${NC}\n"
