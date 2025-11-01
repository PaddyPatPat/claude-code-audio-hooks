#!/bin/bash
# Hook Logger - Records all hook triggers for debugging

LOG_DIR="/tmp/claude_hooks_log"
LOG_FILE="$LOG_DIR/hook_triggers.log"

# Initialize log directory
mkdir -p "$LOG_DIR"

# Function to log hook trigger
log_hook_trigger() {
    local hook_type=$1
    local audio_file=$2
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # Create log entry
    echo "$timestamp | $hook_type | $(basename "$audio_file")" >> "$LOG_FILE"

    # Keep only last 100 entries
    tail -n 100 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
}

# Export function for use in hooks
export -f log_hook_trigger
export LOG_FILE
