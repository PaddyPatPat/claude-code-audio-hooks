# Notification Hook Behavior - Important Clarification

## The Problem

Users expect the **Notification hook** to trigger when Claude Code shows permission prompts like:

```
Do you want to proceed?
  1. Yes
❯ 2. Yes, and don't ask again for similar commands
  3. No, and tell Claude what to do differently (esc)
```

**However, the Notification hook does NOT trigger in this scenario.**

## Why This Happens

According to Claude Code's implementation, the **Notification hook** is designed for a different purpose than permission prompts.

### When Notification Hook DOES Trigger:

Based on testing and observation:
- Desktop notifications
- System-level alerts
- Specific Claude Code notification events
- Error/warning notifications

### When Notification Hook DOES NOT Trigger:

❌ **Permission prompts for bash commands** (like git commit)
❌ **User input requests** (like asking for confirmation)
❌ **Tool execution confirmations** (pre-execution prompts)
❌ **Interactive selection menus** (numbered choices)

## Evidence from Testing

From `/tmp/claude_hooks_log/hook_triggers.log`:

```
2025-11-01 20:31:43 | notification | notification-urgent.mp3  ← Manual test only
2025-11-01 20:33:24 | stop | task-complete.mp3              ← Real usage
2025-11-01 20:40:09 | stop | task-complete.mp3              ← Real usage
```

**Notice:** No `notification` entries during actual Claude Code usage with git commit prompts!

## Solutions

### Option 1: Enable PreToolUse Hook (Recommended for Permission Alerts)

If you want audio notifications **before tool execution** (including git commands):

**Edit `config/user_preferences.json`:**

```json
{
  "enabled_hooks": {
    "notification": true,
    "stop": true,
    "pretooluse": true,    // ← Enable this for pre-execution alerts
    "subagent_stop": true
  }
}
```

**Result:**
- ✓ Audio plays BEFORE every tool execution (including git commit)
- ✓ You'll hear `task-starting.mp3` when Claude is about to run a command
- ⚠️ Warning: This can be noisy! Every Read, Write, Edit, Bash command will trigger audio

**Audio sequence for git commit:**
1. `task-starting.mp3` - PreToolUse fires (before git commit prompt)
2. [You see the permission prompt]
3. `task-complete.mp3` - Stop fires (after you confirm)

### Option 2: Enable UserPromptSubmit Hook

For audio when you **submit a prompt**:

```json
{
  "enabled_hooks": {
    "notification": true,
    "stop": true,
    "userpromptsubmit": true,  // ← Audio when you hit Enter
    "subagent_stop": true
  }
}
```

### Option 3: Accept Current Behavior

The current setup with just `stop` and `subagent_stop` is actually the recommended configuration:
- ✓ Less noisy
- ✓ Only alerts when tasks complete
- ✓ Notification hook remains available for true notifications (if/when they occur)

## Detailed Comparison

| Scenario | Notification Hook | PreToolUse Hook | Stop Hook |
|----------|-------------------|-----------------|-----------|
| Permission prompt appears | ❌ No | ✅ Yes (before) | ❌ No |
| User confirms command | ❌ No | ❌ No | ❌ No |
| Command executes | ❌ No | ❌ No | ❌ No |
| Claude finishes response | ❌ No | ❌ No | ✅ Yes |
| Desktop notification | ✅ Yes | ❌ No | ❌ No |

## Example: Git Commit Flow

With **current config** (notification + stop + subagent_stop):
```
1. Claude prepares git commit
2. [No audio] - permission prompt appears
3. You select option
4. Git commit executes
5. 🔊 task-complete.mp3 plays - Stop hook (Claude finishes response)
```

With **pretooluse enabled**:
```
1. Claude prepares git commit
2. 🔊 task-starting.mp3 plays - PreToolUse hook (before prompt)
3. [Permission prompt appears]
4. You select option
5. Git commit executes
6. 🔊 task-complete.mp3 plays - Stop hook (Claude finishes response)
```

## Recommendation

**For most users: Keep current configuration**
- The Stop hook already provides feedback when Claude finishes
- Adding PreToolUse will make it very noisy (every tool call = audio)

**For users who want audio on permissions: Enable PreToolUse**
- You'll get audio before each tool execution
- Be prepared for frequent audio notifications
- Consider disabling if it becomes too distracting

## Testing

To verify PreToolUse hook works:

```bash
# 1. Enable pretooluse in config/user_preferences.json
# 2. Test it:
bash scripts/test-audio.sh

# 3. Or test manually:
bash ~/.claude/hooks/pretooluse_hook.sh
# Should play task-starting.mp3
```

## Summary

**The "Notification hook doesn't play on permission prompts" is expected behavior, not a bug.**

To get audio on permission prompts:
1. Enable `pretooluse` hook in config
2. Accept that it will be noisy (triggers on every tool call)
3. Or use current config and rely on Stop hook for completion notifications

The Notification hook is reserved for different types of notifications that Claude Code may send in the future or in specific scenarios we haven't encountered yet.
