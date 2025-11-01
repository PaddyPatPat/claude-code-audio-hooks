#!/bin/bash
# Verification script for path detection logic
# Tests if hooks can find the project directory in various scenarios

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get current project directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  Path Detection Verification${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

echo -e "${BLUE}Current project directory:${NC} $PROJECT_DIR"
echo ""

# Test 1: Check if .project_path file exists
echo -e "${YELLOW}Test 1: Check .project_path file${NC}"
if [ -f "$HOME/.claude/hooks/.project_path" ]; then
    RECORDED_PATH=$(cat "$HOME/.claude/hooks/.project_path" | tr -d '\n\r')
    echo -e "${GREEN}✓${NC} .project_path exists"
    echo -e "  Recorded path: $RECORDED_PATH"

    if [ "$RECORDED_PATH" = "$PROJECT_DIR" ]; then
        echo -e "${GREEN}✓${NC} Path matches current project"
    else
        echo -e "${RED}✗${NC} Path mismatch!"
        echo -e "  Expected: $PROJECT_DIR"
        echo -e "  Got: $RECORDED_PATH"
    fi
else
    echo -e "${RED}✗${NC} .project_path not found"
    echo -e "  Run 'bash scripts/install.sh' to create it"
fi
echo ""

# Test 2: Source hook_config.sh and check PROJECT_DIR detection
echo -e "${YELLOW}Test 2: Test hook_config.sh path detection${NC}"
if [ -f "$HOME/.claude/hooks/shared/hook_config.sh" ]; then
    # Create a temporary test script that sources hook_config.sh
    TEMP_TEST=$(mktemp)
    cat > "$TEMP_TEST" << 'EOF'
#!/bin/bash
source "$HOME/.claude/hooks/shared/hook_config.sh"
echo "$PROJECT_DIR"
EOF
    chmod +x "$TEMP_TEST"

    DETECTED_PATH=$($TEMP_TEST)
    rm "$TEMP_TEST"

    echo -e "${GREEN}✓${NC} hook_config.sh loaded successfully"
    echo -e "  Detected PROJECT_DIR: $DETECTED_PATH"

    if [ "$DETECTED_PATH" = "$PROJECT_DIR" ]; then
        echo -e "${GREEN}✓${NC} Path detection working correctly"
    else
        echo -e "${RED}✗${NC} Path detection failed!"
        echo -e "  Expected: $PROJECT_DIR"
        echo -e "  Got: $DETECTED_PATH"
    fi
else
    echo -e "${RED}✗${NC} hook_config.sh not found in ~/.claude/hooks/shared/"
    echo -e "  Run 'bash scripts/install.sh' to install"
fi
echo ""

# Test 3: Check if audio files exist
echo -e "${YELLOW}Test 3: Check audio files accessibility${NC}"
if [ -d "$PROJECT_DIR/audio/default" ]; then
    AUDIO_COUNT=$(find "$PROJECT_DIR/audio/default" -name "*.mp3" | wc -l)
    echo -e "${GREEN}✓${NC} Audio directory exists"
    echo -e "  Found $AUDIO_COUNT audio files"

    # List audio files
    echo -e "  Audio files:"
    find "$PROJECT_DIR/audio/default" -name "*.mp3" -exec basename {} \; | sed 's/^/    - /'
else
    echo -e "${RED}✗${NC} Audio directory not found: $PROJECT_DIR/audio/default"
fi
echo ""

# Test 4: Check config file
echo -e "${YELLOW}Test 4: Check configuration file${NC}"
if [ -f "$PROJECT_DIR/config/user_preferences.json" ]; then
    echo -e "${GREEN}✓${NC} Configuration file exists"
    echo -e "  Path: $PROJECT_DIR/config/user_preferences.json"
else
    echo -e "${RED}✗${NC} Configuration file not found"
fi
echo ""

# Test 5: Simulate hook execution
echo -e "${YELLOW}Test 5: Simulate hook execution${NC}"
if [ -f "$HOME/.claude/hooks/stop_hook.sh" ]; then
    echo -e "${GREEN}✓${NC} stop_hook.sh installed"

    # Try to execute the hook (in dry-run mode, just check if it runs)
    if bash "$HOME/.claude/hooks/stop_hook.sh" 2>&1 | grep -q "error" ; then
        echo -e "${RED}✗${NC} Hook execution failed"
    else
        echo -e "${GREEN}✓${NC} Hook executes without errors"
    fi
else
    echo -e "${RED}✗${NC} stop_hook.sh not found"
    echo -e "  Run 'bash scripts/install.sh' to install"
fi
echo ""

# Summary
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  Summary${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""
echo -e "Project location: ${GREEN}$PROJECT_DIR${NC}"
echo ""
echo -e "For other users installing this project:"
echo -e "1. Clone the repository to any location"
echo -e "2. Run ${GREEN}bash scripts/install.sh${NC}"
echo -e "3. The installation will automatically record the project path"
echo -e "4. Hooks will find audio files regardless of installation location"
echo ""
echo -e "Supported installation locations:"
echo -e "  • ~/claude-code-audio-hooks"
echo -e "  • ~/projects/claude-code-audio-hooks"
echo -e "  • ~/Documents/claude-code-audio-hooks"
echo -e "  • ~/repos/claude-code-audio-hooks"
echo -e "  • ~/git/claude-code-audio-hooks"
echo -e "  • ~/src/claude-code-audio-hooks"
echo -e "  • Any custom location (via .project_path)"
echo ""
