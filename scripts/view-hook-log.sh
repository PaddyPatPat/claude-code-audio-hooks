#!/bin/bash
# View Hook Trigger Log
# Shows which hooks have been triggered and when

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

LOG_FILE="/tmp/claude_hooks_log/hook_triggers.log"

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  Claude Code Audio Hooks - Trigger Log${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

if [ ! -f "$LOG_FILE" ]; then
    echo -e "${YELLOW}No log file found.${NC}"
    echo "The log file will be created automatically when hooks are triggered."
    echo ""
    echo "Try using Claude Code and the log will populate."
    exit 0
fi

# Count triggers by type
echo -e "${CYAN}Summary:${NC}"
echo ""

total_count=$(wc -l < "$LOG_FILE")
echo -e "Total hook triggers: ${GREEN}$total_count${NC}"
echo ""

echo "Triggers by hook type:"
for hook_type in notification stop pretooluse posttooluse userpromptsubmit subagent_stop precompact session_start session_end; do
    count=$(grep -c "| $hook_type |" "$LOG_FILE" 2>/dev/null || echo "0")
    # Remove any whitespace/newlines and ensure it's a valid integer
    count=$(echo "$count" | tr -d '\n\r' | xargs)
    # Default to 0 if empty or invalid
    count=${count:-0}
    if [ "$count" -gt 0 ] 2>/dev/null; then
        # Get the corresponding audio file name
        audio=$(grep "| $hook_type |" "$LOG_FILE" | tail -1 | awk -F'|' '{print $3}' | xargs)
        echo -e "  ${YELLOW}$hook_type${NC}: $count times → $audio"
    fi
done

echo ""
echo -e "${CYAN}Recent triggers (last 20):${NC}"
echo ""
echo -e "${YELLOW}Timestamp           | Hook Type      | Audio File${NC}"
echo "-----------------------------------------------------------"

tail -n 20 "$LOG_FILE" | while IFS='|' read -r timestamp hook_type audio; do
    # Trim whitespace
    timestamp=$(echo "$timestamp" | xargs)
    hook_type=$(echo "$hook_type" | xargs)
    audio=$(echo "$audio" | xargs)

    printf "%-19s | %-14s | %s\n" "$timestamp" "$hook_type" "$audio"
done

echo ""
echo -e "${BLUE}================================================${NC}"
echo ""
echo "Log file location: $LOG_FILE"
echo ""
echo -e "${CYAN}Understanding the results:${NC}"
echo ""
echo -e "${GREEN}stop${NC} - Triggered every time Claude finishes responding"
echo -e "  (This is why you hear task-complete.mp3 most often)"
echo ""
echo -e "${GREEN}notification${NC} - Triggered when Claude needs authorization/confirmation"
echo -e "  (Less frequent - only for special permissions)"
echo ""
echo -e "${GREEN}subagent_stop${NC} - Triggered when background tasks complete"
echo -e "  (Occasional - when using Task tool)"
echo ""
echo "To monitor in real-time:"
echo -e "  ${CYAN}tail -f $LOG_FILE${NC}"
echo ""
