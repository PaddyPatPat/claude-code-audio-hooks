# Hook Triggering Guide

## Understanding Why You Mostly Hear `task-complete.mp3`

This is **completely normal behavior**! Here's why:

## Hook Trigger Frequency

### 🔊 **Stop Hook** (task-complete.mp3)
- **Frequency:** ⭐⭐⭐⭐⭐ (100% - Every response)
- **Triggers when:** Claude finishes responding to you
- **Why it's most common:** This happens every single time Claude completes a response
- **Audio:** "Task completed successfully."

### 🚨 **Notification Hook** (notification-urgent.mp3)
- **Frequency:** ⭐ (5-10% - Occasional)
- **Triggers when:**
  - Claude needs special authorization for a command
  - User confirmation is required for important operations
  - Using AskUserQuestion tool
- **Why it's rare:** Most operations are already pre-authorized in your hooks configuration
- **Audio:** "Attention! Claude needs your authorization."

### 🤖 **SubagentStop Hook** (subagent-complete.mp3)
- **Frequency:** ⭐⭐ (10-20% - Sometimes)
- **Triggers when:**
  - Claude launches a subagent using the Task tool
  - Background exploration or research tasks complete
- **Why it's occasional:** Only happens for complex multi-step tasks
- **Audio:** "Subagent task completed."

## Real-World Example

In a typical Claude Code session with 10 interactions:

```
Stop Hook:          ⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐ (10 times - every response)
Notification Hook:  ⭐                  (1 time - when permission needed)
SubagentStop Hook:  ⭐⭐                (2 times - for complex tasks)
```

**Result:** You'll mostly hear `task-complete.mp3` because Stop hook triggers most frequently!

## How to Hear More Audio Variety

### Option 1: Enable More Hooks (Recommended for Advanced Users)

Edit `config/user_preferences.json` and enable these hooks:

```json
{
  "enabled_hooks": {
    "notification": true,
    "stop": true,
    "pretooluse": true,      // ← Enable this for tool execution notifications
    "posttooluse": false,    // Keep disabled (too noisy)
    "userpromptsubmit": true, // ← Enable this to hear audio when you submit prompts
    "subagent_stop": true,
    "precompact": false,
    "session_start": true,   // ← Enable this to hear audio when session starts
    "session_end": true      // ← Enable this to hear audio when session ends
  }
}
```

**⚠️ Warning:** Enabling `pretooluse` and `posttooluse` will play audio for EVERY tool execution, which can be very noisy!

### Option 2: Monitor Hook Triggers

Use the log viewer to see which hooks are actually being triggered:

```bash
# View hook trigger history
bash scripts/view-hook-log.sh

# Monitor hooks in real-time
tail -f /tmp/claude_hooks_log/hook_triggers.log
```

### Option 3: Create Complex Tasks

To hear more `notification-urgent.mp3` and `subagent-complete.mp3`:

**For Notification Hook:**
- Ask Claude to run potentially risky commands
- Request file operations in protected directories
- Ask Claude to make important decisions

**For SubagentStop Hook:**
- Give Claude complex multi-step tasks
- Ask Claude to explore or research the codebase
- Request background analysis or refactoring

Example prompt:
```
"Please use the Task tool to explore the entire codebase and
find all authentication-related code, then refactor it to use
a consistent pattern."
```

This will trigger:
1. **SubagentStop** when exploration completes
2. **Notification** if refactoring needs permission
3. **Stop** when the entire response is done

## Audio File Reference

| Hook Type       | Audio File                  | Content                                      |
|----------------|-----------------------------|--------------------------------------------|
| Notification   | notification-urgent.mp3     | "Attention! Claude needs your authorization." |
| Stop           | task-complete.mp3           | "Task completed successfully."             |
| PreToolUse     | task-starting.mp3           | "Starting task."                           |
| PostToolUse    | task-progress.mp3           | "Task in progress."                        |
| UserPromptSubmit | prompt-received.mp3        | "Prompt received."                         |
| SubagentStop   | subagent-complete.mp3       | "Subagent task completed."                 |
| PreCompact     | notification-info.mp3       | "Information: compacting conversation."     |
| SessionStart   | session-start.mp3           | "Session started."                         |
| SessionEnd     | session-end.mp3             | "Session ended."                           |

## Troubleshooting

### "I only hear task-complete.mp3"
✅ **This is normal!** Stop hook is the most frequent hook.

### "I never hear notification-urgent.mp3"
This means Claude doesn't need special permissions for your tasks. Try:
- Asking Claude to run system commands
- Requesting file modifications in protected areas

### "I want to hear more audio variety"
Enable more hooks in `config/user_preferences.json` (see Option 1 above).

## Verification Tools

```bash
# Test all enabled hooks
bash scripts/test-enabled-hooks-audio.sh

# View trigger history
bash scripts/view-hook-log.sh

# Monitor in real-time
tail -f /tmp/claude_hooks_log/hook_triggers.log
```

## Summary

**It's completely normal to mostly hear `task-complete.mp3`** because:
1. Stop hook triggers on every response (100%)
2. Notification hook only triggers when permission needed (5-10%)
3. SubagentStop hook only triggers for complex tasks (10-20%)

The system is working as designed! Each hook serves a specific purpose with different trigger frequencies.
