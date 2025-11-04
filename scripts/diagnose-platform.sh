#!/bin/bash
# Platform Diagnostic Script for Claude Code Audio Hooks
# Helps identify environment and potential issues

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${BLUE}${BOLD}================================================${NC}"
echo -e "${BLUE}${BOLD}  Claude Code Audio Hooks${NC}"
echo -e "${BLUE}${BOLD}  Platform Diagnostic Tool${NC}"
echo -e "${BLUE}${BOLD}================================================${NC}"
echo ""

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

#=============================================================================
# SECTION 1: ENVIRONMENT DETECTION
#=============================================================================

echo -e "${CYAN}${BOLD}[1/7] Environment Detection${NC}"
echo ""

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if grep -qi microsoft /proc/version 2>/dev/null; then
        ENVIRONMENT="WSL"
        echo -e "  ${GREEN}✓${NC} Platform: ${BOLD}WSL (Windows Subsystem for Linux)${NC}"
    else
        ENVIRONMENT="Linux"
        echo -e "  ${GREEN}✓${NC} Platform: ${BOLD}Native Linux${NC}"
    fi

    # Show Linux distribution
    if [ -f /etc/os-release ]; then
        DISTRO=$(grep "^PRETTY_NAME" /etc/os-release | cut -d'"' -f2)
        echo -e "  ${GREEN}✓${NC} Distribution: $DISTRO"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    ENVIRONMENT="macOS"
    echo -e "  ${GREEN}✓${NC} Platform: ${BOLD}macOS${NC}"
    MACOS_VERSION=$(sw_vers -productVersion)
    echo -e "  ${GREEN}✓${NC} Version: macOS $MACOS_VERSION"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "mingw"* ]]; then
    ENVIRONMENT="Git Bash"
    echo -e "  ${GREEN}✓${NC} Platform: ${BOLD}Git Bash (MSYS/MINGW)${NC}"
    echo -e "  ${GREEN}✓${NC} OS: Windows"
elif [[ "$OSTYPE" == "cygwin" ]]; then
    ENVIRONMENT="Cygwin"
    echo -e "  ${GREEN}✓${NC} Platform: ${BOLD}Cygwin${NC}"
    echo -e "  ${GREEN}✓${NC} OS: Windows"
else
    ENVIRONMENT="Unknown"
    echo -e "  ${YELLOW}⚠${NC} Platform: ${BOLD}Unknown ($OSTYPE)${NC}"
fi

echo -e "  ${GREEN}✓${NC} Shell: $SHELL"
echo -e "  ${GREEN}✓${NC} User: $(whoami)"
echo -e "  ${GREEN}✓${NC} Home: $HOME"
echo ""

#=============================================================================
# SECTION 2: DEPENDENCIES CHECK
#=============================================================================

echo -e "${CYAN}${BOLD}[2/7] Dependencies Check${NC}"
echo ""

# Check bash
if command -v bash &> /dev/null; then
    BASH_VERSION_INFO=$(bash --version | head -n1)
    echo -e "  ${GREEN}✓${NC} bash: $BASH_VERSION_INFO"
else
    echo -e "  ${RED}✗${NC} bash: Not found"
fi

# Check git
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version)
    echo -e "  ${GREEN}✓${NC} git: $GIT_VERSION"
else
    echo -e "  ${RED}✗${NC} git: Not found"
fi

# Check Claude Code
if command -v claude &> /dev/null; then
    CLAUDE_VERSION=$(claude --version 2>&1)
    echo -e "  ${GREEN}✓${NC} Claude Code: $CLAUDE_VERSION"
else
    echo -e "  ${RED}✗${NC} Claude Code: Not found"
    echo -e "      Install from: https://docs.claude.com/claude-code"
fi

# Check Python
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo -e "  ${GREEN}✓${NC} Python: $PYTHON_VERSION"
else
    echo -e "  ${YELLOW}⚠${NC} Python 3: Not found (optional - limited config without it)"
fi

echo ""

#=============================================================================
# SECTION 3: AUDIO CAPABILITIES
#=============================================================================

echo -e "${CYAN}${BOLD}[3/7] Audio Playback Capabilities${NC}"
echo ""

case $ENVIRONMENT in
    "WSL")
        echo -e "  ${BLUE}ℹ${NC} WSL uses PowerShell.exe for audio playback"

        if command -v powershell.exe &> /dev/null; then
            echo -e "  ${GREEN}✓${NC} PowerShell.exe: Available"
        else
            echo -e "  ${RED}✗${NC} PowerShell.exe: Not found in PATH"
        fi

        if command -v wslpath &> /dev/null; then
            echo -e "  ${GREEN}✓${NC} wslpath: Available (for path conversion)"
        else
            echo -e "  ${RED}✗${NC} wslpath: Not found"
        fi
        ;;

    "Git Bash")
        echo -e "  ${BLUE}ℹ${NC} Git Bash uses PowerShell.exe for audio playback"

        if command -v powershell.exe &> /dev/null; then
            echo -e "  ${GREEN}✓${NC} PowerShell.exe: Available"

            # Test PowerShell
            if powershell.exe -Command "Write-Host 'OK'" &> /dev/null; then
                echo -e "  ${GREEN}✓${NC} PowerShell test: Success"
            else
                echo -e "  ${RED}✗${NC} PowerShell test: Failed"
            fi
        else
            echo -e "  ${RED}✗${NC} PowerShell.exe: Not found in PATH"
        fi
        ;;

    "Cygwin")
        echo -e "  ${BLUE}ℹ${NC} Cygwin uses PowerShell.exe for audio playback"

        if command -v powershell.exe &> /dev/null; then
            echo -e "  ${GREEN}✓${NC} PowerShell.exe: Available"
        else
            echo -e "  ${RED}✗${NC} PowerShell.exe: Not found in PATH"
        fi

        if command -v cygpath &> /dev/null; then
            echo -e "  ${GREEN}✓${NC} cygpath: Available (for path conversion)"
        else
            echo -e "  ${RED}✗${NC} cygpath: Not found"
        fi
        ;;

    "macOS")
        echo -e "  ${BLUE}ℹ${NC} macOS uses afplay (built-in)"

        if command -v afplay &> /dev/null; then
            echo -e "  ${GREEN}✓${NC} afplay: Available"
        else
            echo -e "  ${RED}✗${NC} afplay: Not found (should be built into macOS)"
        fi
        ;;

    "Linux")
        echo -e "  ${BLUE}ℹ${NC} Linux supports multiple audio players"

        AUDIO_PLAYERS=0

        if command -v mpg123 &> /dev/null; then
            echo -e "  ${GREEN}✓${NC} mpg123: Available (recommended for MP3)"
            AUDIO_PLAYERS=$((AUDIO_PLAYERS + 1))
        else
            echo -e "  ${YELLOW}⚠${NC} mpg123: Not installed (recommended)"
        fi

        if command -v aplay &> /dev/null; then
            echo -e "  ${GREEN}✓${NC} aplay: Available (ALSA)"
            AUDIO_PLAYERS=$((AUDIO_PLAYERS + 1))
        else
            echo -e "  ${YELLOW}⚠${NC} aplay: Not installed"
        fi

        if command -v paplay &> /dev/null; then
            echo -e "  ${GREEN}✓${NC} paplay: Available (PulseAudio)"
            AUDIO_PLAYERS=$((AUDIO_PLAYERS + 1))
        else
            echo -e "  ${YELLOW}⚠${NC} paplay: Not installed"
        fi

        if command -v ffplay &> /dev/null; then
            echo -e "  ${GREEN}✓${NC} ffplay: Available (FFmpeg)"
            AUDIO_PLAYERS=$((AUDIO_PLAYERS + 1))
        else
            echo -e "  ${YELLOW}⚠${NC} ffplay: Not installed"
        fi

        if [ $AUDIO_PLAYERS -eq 0 ]; then
            echo -e "  ${RED}✗${NC} No audio players found!"
            echo -e "      Install one with:"
            echo -e "      sudo apt-get install mpg123    # Ubuntu/Debian"
            echo -e "      sudo dnf install mpg123         # Fedora/RHEL"
            echo -e "      sudo pacman -S mpg123           # Arch"
        fi
        ;;
esac

echo ""

#=============================================================================
# SECTION 4: INSTALLATION STATUS
#=============================================================================

echo -e "${CYAN}${BOLD}[4/7] Installation Status${NC}"
echo ""

# Check Claude directory
if [ -d "$HOME/.claude" ]; then
    echo -e "  ${GREEN}✓${NC} Claude directory exists: ~/.claude"
else
    echo -e "  ${RED}✗${NC} Claude directory not found: ~/.claude"
fi

# Check hooks directory
if [ -d "$HOME/.claude/hooks" ]; then
    echo -e "  ${GREEN}✓${NC} Hooks directory exists: ~/.claude/hooks"

    # Count hook files
    HOOK_COUNT=$(find "$HOME/.claude/hooks" -maxdepth 1 -name "*_hook.sh" 2>/dev/null | wc -l)
    if [ $HOOK_COUNT -gt 0 ]; then
        echo -e "  ${GREEN}✓${NC} Found $HOOK_COUNT hook script(s)"
    else
        echo -e "  ${YELLOW}⚠${NC} No hook scripts found"
    fi
else
    echo -e "  ${RED}✗${NC} Hooks directory not found: ~/.claude/hooks"
fi

# Check shared library
if [ -f "$HOME/.claude/hooks/shared/hook_config.sh" ]; then
    echo -e "  ${GREEN}✓${NC} Shared library installed"
else
    echo -e "  ${RED}✗${NC} Shared library not found"
fi

# Check .project_path
if [ -f "$HOME/.claude/hooks/.project_path" ]; then
    RECORDED_PATH=$(cat "$HOME/.claude/hooks/.project_path" | tr -d '\n\r')
    echo -e "  ${GREEN}✓${NC} Project path recorded"
    echo -e "      Path: $RECORDED_PATH"

    if [ -d "$RECORDED_PATH" ]; then
        echo -e "  ${GREEN}✓${NC} Project directory exists"
    else
        echo -e "  ${RED}✗${NC} Project directory not found at recorded path!"
    fi
else
    echo -e "  ${YELLOW}⚠${NC} Project path not recorded (.project_path missing)"
fi

# Check settings files
if [ -f "$HOME/.claude/settings.json" ]; then
    echo -e "  ${GREEN}✓${NC} Settings file exists"

    # Check if hooks are configured
    if grep -q "hooks" "$HOME/.claude/settings.json" 2>/dev/null; then
        echo -e "  ${GREEN}✓${NC} Hooks configured in settings.json"
    else
        echo -e "  ${YELLOW}⚠${NC} Hooks not configured in settings.json"
    fi
else
    echo -e "  ${RED}✗${NC} Settings file not found"
fi

if [ -f "$HOME/.claude/settings.local.json" ]; then
    echo -e "  ${GREEN}✓${NC} Local settings file exists"
else
    echo -e "  ${YELLOW}⚠${NC} Local settings file not found"
fi

echo ""

#=============================================================================
# SECTION 5: PROJECT FILES
#=============================================================================

echo -e "${CYAN}${BOLD}[5/7] Project Files${NC}"
echo ""

echo -e "  ${BLUE}ℹ${NC} Current project directory: $PROJECT_DIR"

# Check essential files
if [ -f "$PROJECT_DIR/scripts/install.sh" ]; then
    echo -e "  ${GREEN}✓${NC} Installer script exists"
else
    echo -e "  ${RED}✗${NC} Installer script not found"
fi

if [ -d "$PROJECT_DIR/audio/default" ]; then
    AUDIO_COUNT=$(find "$PROJECT_DIR/audio/default" -name "*.mp3" 2>/dev/null | wc -l)
    echo -e "  ${GREEN}✓${NC} Audio directory exists"
    echo -e "  ${GREEN}✓${NC} Found $AUDIO_COUNT audio file(s)"
else
    echo -e "  ${RED}✗${NC} Audio directory not found"
fi

if [ -f "$PROJECT_DIR/config/user_preferences.json" ]; then
    echo -e "  ${GREEN}✓${NC} Configuration file exists"
else
    echo -e "  ${YELLOW}⚠${NC} Configuration file not found"
fi

echo ""

#=============================================================================
# SECTION 6: PERMISSIONS
#=============================================================================

echo -e "${CYAN}${BOLD}[6/7] Permissions Check${NC}"
echo ""

# Check hook executability
if [ -f "$HOME/.claude/hooks/stop_hook.sh" ]; then
    if [ -x "$HOME/.claude/hooks/stop_hook.sh" ]; then
        echo -e "  ${GREEN}✓${NC} Hook scripts are executable"
    else
        echo -e "  ${YELLOW}⚠${NC} Hook scripts may not be executable"
        echo -e "      Run: chmod +x ~/.claude/hooks/*.sh"
    fi
fi

# Check settings.local.json permissions
if [ -f "$HOME/.claude/settings.local.json" ]; then
    if grep -q "claude/hooks" "$HOME/.claude/settings.local.json" 2>/dev/null; then
        echo -e "  ${GREEN}✓${NC} Hook permissions configured in settings.local.json"
    else
        echo -e "  ${YELLOW}⚠${NC} Hook permissions may not be configured"
    fi
fi

echo ""

#=============================================================================
# SECTION 7: RECOMMENDATIONS
#=============================================================================

echo -e "${CYAN}${BOLD}[7/7] Recommendations${NC}"
echo ""

# Generate recommendations based on findings
RECOMMENDATIONS=()

# Check if not installed
if [ ! -d "$HOME/.claude/hooks" ] || [ ! -f "$HOME/.claude/hooks/shared/hook_config.sh" ]; then
    RECOMMENDATIONS+=("${YELLOW}⚠${NC} System not installed. Run: ${BOLD}bash $PROJECT_DIR/scripts/install.sh${NC}")
fi

# Check Python
if ! command -v python3 &> /dev/null; then
    RECOMMENDATIONS+=("${YELLOW}⚠${NC} Python 3 not found. Install it for full configuration support.")
    RECOMMENDATIONS+=("   Without Python, only 3 default hooks will be enabled: notification, stop, subagent_stop")
fi

# Platform-specific recommendations
case $ENVIRONMENT in
    "Git Bash")
        if ! command -v powershell.exe &> /dev/null; then
            RECOMMENDATIONS+=("${RED}✗${NC} PowerShell.exe not in PATH. Audio won't work!")
            RECOMMENDATIONS+=("   Add PowerShell to PATH or reinstall Git for Windows")
        fi
        ;;

    "WSL")
        if ! command -v wslpath &> /dev/null; then
            RECOMMENDATIONS+=("${RED}✗${NC} wslpath not found. Make sure you're using WSL 2")
        fi
        ;;

    "Linux")
        if [ $AUDIO_PLAYERS -eq 0 ]; then
            RECOMMENDATIONS+=("${RED}✗${NC} No audio players installed!")
            RECOMMENDATIONS+=("   Install mpg123: ${BOLD}sudo apt-get install mpg123${NC}")
        fi
        ;;
esac

# Check if .project_path exists
if [ ! -f "$HOME/.claude/hooks/.project_path" ]; then
    RECOMMENDATIONS+=("${YELLOW}⚠${NC} Project path not recorded. Re-run installer to fix.")
fi

# Display recommendations
if [ ${#RECOMMENDATIONS[@]} -eq 0 ]; then
    echo -e "  ${GREEN}✓${NC} ${BOLD}All checks passed! System looks good!${NC}"
    echo ""
    echo -e "  ${BLUE}ℹ${NC} Next steps:"
    echo -e "     1. Test audio: ${BOLD}bash $PROJECT_DIR/scripts/test-audio.sh${NC}"
    echo -e "     2. Restart Claude Code"
    echo -e "     3. Try a command: ${BOLD}claude \"What is 2+2?\"${NC}"
else
    echo -e "  ${YELLOW}⚠${NC} ${BOLD}Found some issues:${NC}"
    echo ""
    for rec in "${RECOMMENDATIONS[@]}"; do
        echo -e "  $rec"
    done
fi

echo ""

#=============================================================================
# SUMMARY
#=============================================================================

echo -e "${BLUE}${BOLD}================================================${NC}"
echo -e "${BLUE}${BOLD}  Summary${NC}"
echo -e "${BLUE}${BOLD}================================================${NC}"
echo ""

echo -e "${BOLD}Platform:${NC} $ENVIRONMENT"
echo -e "${BOLD}Project:${NC} $PROJECT_DIR"
echo -e "${BOLD}Claude Directory:${NC} ~/.claude"
echo ""

echo -e "${BOLD}Useful Commands:${NC}"
echo -e "  • Install/reinstall:   ${CYAN}bash $PROJECT_DIR/scripts/install.sh${NC}"
echo -e "  • Verify installation: ${CYAN}bash $PROJECT_DIR/scripts/verify-path-detection.sh${NC}"
echo -e "  • Test audio:          ${CYAN}bash $PROJECT_DIR/scripts/test-audio.sh${NC}"
echo -e "  • Configure hooks:     ${CYAN}bash $PROJECT_DIR/scripts/configure.sh${NC}"
echo -e "  • Check setup:         ${CYAN}bash $PROJECT_DIR/scripts/check-setup.sh${NC}"
echo ""

echo -e "${BOLD}Documentation:${NC}"
echo -e "  • Cross-platform guide: ${CYAN}$PROJECT_DIR/docs/CROSS_PLATFORM_INSTALLATION.md${NC}"
echo -e "  • Main README:          ${CYAN}$PROJECT_DIR/README.md${NC}"
echo ""

echo -e "For issues, visit: ${CYAN}https://github.com/ChanMeng666/claude-code-audio-hooks/issues${NC}"
echo ""
