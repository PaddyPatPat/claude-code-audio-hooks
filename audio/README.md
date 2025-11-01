# Audio Files Directory

This directory contains the audio files used for Claude Code notifications.

## 📁 Directory Structure

- **`default/`** - Default audio files provided with the project
- **`custom/`** - Your custom audio files (optional)
- **`legacy/`** - Original audio file from v1.0 (for reference)

## ⚠️ IMPORTANT: Replace Placeholder Audio Files!

### Current Status

The audio files in `default/` are currently **PLACEHOLDERS** - they all use the same audio file for testing purposes.

To get the full experience with different notification sounds, you should:

1. **Create custom audio files** for each notification type
2. **Replace the placeholder files** in `default/`
3. Or **add your own files** to `custom/` and update the configuration

### Required Audio Files

| File Name | Purpose | Status |
|-----------|---------|--------|
| `notification-urgent.mp3` | ⚠️ Authorization/confirmation requests | 🔴 PLACEHOLDER - **REPLACE THIS!** |
| `notification-info.mp3` | General notifications | 🟡 Placeholder |
| `task-complete.mp3` | ✅ Task completion | ✅ **Original file** (already good!) |
| `task-starting.mp3` | Before tool execution | 🟡 Placeholder |
| `task-progress.mp3` | After tool execution | 🟡 Placeholder |
| `prompt-received.mp3` | User prompt submission | 🟡 Placeholder |
| `subagent-complete.mp3` | Subagent task completion | 🟡 Placeholder |
| `session-start.mp3` | Session start | 🟡 Placeholder |
| `session-end.mp3` | Session end | 🟡 Placeholder |

### Priority for Replacement

**🔴 Critical (Replace First):**
- `notification-urgent.mp3` - Most important! This is for authorization requests.

**🟡 High Priority:**
- `subagent-complete.mp3` - For background task completion
- `notification-info.mp3` - For general notifications

**🟢 Optional:**
- All others - Nice to have, but not essential

## 🎤 How to Create Audio Files

See **`../docs/AUDIO_CREATION.md`** for detailed instructions on:
- Using ElevenLabs (recommended, free tier available)
- Using other TTS services
- Recording your own voice
- Finding royalty-free sounds

### Quick Start with ElevenLabs

1. Go to [ElevenLabs.io](https://elevenlabs.io)
2. Sign up (free tier: 10,000 characters/month)
3. Create these voices:
   - **notification-urgent:** "Hey! I need your input" (2-3 seconds)
   - **task-complete:** "Done!" or "Task complete" (2 seconds)
   - **notification-info:** "Notification" (1-2 seconds)
4. Download as MP3
5. Replace files in this directory

### Example Commands

```bash
# Replace notification-urgent (most important!)
cp ~/Downloads/urgent-notification.mp3 ~/claude-code-audio-hooks/audio/default/notification-urgent.mp3

# Test the new audio
bash ~/claude-code-audio-hooks/scripts/test-audio.sh
```

## 📂 Using Custom Audio Files

If you want to keep the defaults and use your own:

1. Place your audio files in `custom/` directory
2. Edit `../config/user_preferences.json`:
   ```json
   {
     "audio_files": {
       "notification": "custom/my-urgent-sound.mp3"
     }
   }
   ```
3. Test: `bash ~/claude-code-audio-hooks/scripts/test-audio.sh`

## 📏 Audio File Specifications

**Requirements:**
- **Format:** MP3
- **Duration:** 1-3 seconds (ideal)
- **Sample Rate:** 44.1 kHz
- **Bit Rate:** 128 kbps or higher
- **Volume:** Normalized (consistent across all files)

**Tips:**
- Keep files short (under 3 seconds)
- Make them pleasant (you'll hear them often!)
- Use consistent volume levels
- Test them in actual usage

## 🧪 Testing Audio Files

```bash
# Test all enabled audio notifications
cd ~/claude-code-audio-hooks
bash scripts/test-audio.sh

# Test specific file manually
cd ~/claude-code-audio-hooks
bash -c "source hooks/shared/hook_config.sh && test_audio_playback 'audio/default/notification-urgent.mp3'"
```

## 🎯 Recommended TTS Text

For ElevenLabs or other TTS services:

| File | Recommended Text |
|------|------------------|
| notification-urgent.mp3 | "Hey! I need your input" or "Confirmation needed" |
| task-complete.mp3 | "Done!" or "Task complete" |
| notification-info.mp3 | "Notification" or "Notice" |
| subagent-complete.mp3 | "Agent finished" or "Background task done" |
| task-starting.mp3 | "Starting..." or simple beep |
| prompt-received.mp3 | "Got it!" or "Received" |
| session-start.mp3 | "Ready to code!" or "Hello!" |
| session-end.mp3 | "Goodbye!" or "See you next time" |

## 📚 More Help

- **Full Guide:** `docs/AUDIO_CREATION.md`
- **Configuration:** `docs/CONFIGURATION.md`
- **GitHub Issues:** Report problems or ask questions

---

**Don't forget:** The most important file to replace is `notification-urgent.mp3` - this is what you'll hear when Claude needs your authorization!
