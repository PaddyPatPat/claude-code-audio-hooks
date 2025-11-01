# Audio File Creation Guide

> Learn how to create custom notification sounds for Claude Code Audio Hooks

This guide will walk you through creating professional-quality audio notifications for each hook type using AI text-to-speech services like ElevenLabs.

---

## 📋 Table of Contents

- [Audio File Requirements](#audio-file-requirements)
- [Recommended Audio Files](#recommended-audio-files)
- [Creating Audio with ElevenLabs](#creating-audio-with-elevenlabs)
- [Alternative Methods](#alternative-methods)
- [Audio File Specifications](#audio-file-specifications)
- [Installation and Replacement](#installation-and-replacement)
- [Tips for Great Notifications](#tips-for-great-notifications)

---

## 🎵 Audio File Requirements

### Required Audio Files

The project needs 9 audio files for different notification types:

| File Name | Purpose | Recommended Duration | Importance |
|-----------|---------|---------------------|------------|
| `notification-urgent.mp3` | Authorization/confirmation requests | 2-3s | **Critical** |
| `notification-info.mp3` | General notifications | 1-2s | Medium |
| `task-complete.mp3` | Task completion (Stop hook) | 2-3s | **High** |
| `task-starting.mp3` | Before tool execution | 1s | Low |
| `task-progress.mp3` | After tool execution | 1s | Low |
| `prompt-received.mp3` | User prompt submission | 1s | Low |
| `subagent-complete.mp3` | Subagent task completion | 2s | Medium |
| `session-start.mp3` | Session start | 2s | Low |
| `session-end.mp3` | Session end | 2s | Low |

### Priority Levels

**Must Have (Critical):**
- `notification-urgent.mp3` - For authorization requests
- `task-complete.mp3` - For task completion (already provided)

**Should Have (High Priority):**
- `subagent-complete.mp3` - For background tasks
- `notification-info.mp3` - For general notifications

**Nice to Have (Optional):**
- All others - For complete experience

---

## 🎯 Recommended Audio Files

### 1. notification-urgent.mp3 (MOST IMPORTANT)

**Purpose:** Alerts you when Claude needs your authorization or confirmation

**Suggested TTS Text:**
- "Hey! I need your input"
- "Confirmation needed"
- "Your authorization is required"
- "Please confirm"

**Characteristics:**
- **Tone:** Attention-grabbing but not alarming
- **Volume:** Slightly louder than others
- **Pitch:** Mid-to-high range for noticeable
- **Duration:** 2-3 seconds

**Voice Recommendations (ElevenLabs):**
- **Adam** - Clear, professional male voice
- **Antoni** - Warm, friendly male voice
- **Rachel** - Professional female voice
- **Bella** - Friendly female voice

---

### 2. task-complete.mp3

**Purpose:** Notifies when Claude finishes a task

**Suggested TTS Text:**
- "Done!"
- "Task complete"
- "Finished!"
- "All set!"

**Characteristics:**
- **Tone:** Pleasant, completion sound
- **Volume:** Standard
- **Pitch:** Neutral to low (satisfying)
- **Duration:** 2-3 seconds

**Note:** You already have this file (the original `hey-chan-please-help-me.mp3`). You can keep it or replace it!

---

### 3. subagent-complete.mp3

**Purpose:** Alerts when background/subagent tasks complete

**Suggested TTS Text:**
- "Subagent complete"
- "Background task done"
- "Agent finished"

**Characteristics:**
- Similar to task-complete but slightly different
- Can be shorter (2 seconds)

---

### 4. notification-info.mp3

**Purpose:** General information notifications

**Suggested TTS Text:**
- "Notification"
- "Info"
- "Notice"
- Simple beep sound

**Characteristics:**
- **Tone:** Neutral, informative
- **Volume:** Standard
- **Duration:** 1-2 seconds

---

### 5. task-starting.mp3

**Purpose:** Brief acknowledgment before tool execution

**Suggested TTS Text:**
- "Starting..."
- "Working..."
- Simple short beep

**Characteristics:**
- **Tone:** Quick, non-intrusive
- **Duration:** 1 second or less
- **Volume:** Softer than others

**Note:** Only needed if you enable PreToolUse hook (disabled by default)

---

### 6-9. Other Audio Files

For the remaining files (task-progress, prompt-received, session-start, session-end), you can either:
- Create custom TTS
- Use simple system beeps
- Copy from existing files
- Skip them if you don't plan to enable those hooks

---

## 🎤 Creating Audio with ElevenLabs

### Step 1: Sign Up for ElevenLabs

1. Visit [ElevenLabs](https://elevenlabs.io)
2. Sign up for a free account
3. You get **10,000 characters per month** for free (enough for all notifications!)

### Step 2: Generate Audio Files

For each audio file you need:

1. **Go to Text to Speech**
   - Click on "Text to Speech" in the sidebar

2. **Select a Voice**
   - Browse available voices
   - Listen to previews
   - Recommended: Adam (male), Rachel (female) for professional sound

3. **Enter Your Text**
   - Type the notification message (see recommendations above)
   - Keep it short (1-5 words)

4. **Adjust Settings**
   - **Stability:** 50-70% (prevents monotone)
   - **Similarity:** 70-90% (maintains voice consistency)
   - **Style Exaggeration:** 0-30% (depending on urgency)

5. **Generate Audio**
   - Click "Generate"
   - Wait a few seconds
   - Listen to the preview

6. **Download**
   - Click the download button
   - Save as descriptive name
   - Format: MP3

### Step 3: Optimize Audio Files

After downloading from ElevenLabs, you may want to:

1. **Trim Silence**
   - Remove leading/trailing silence
   - Tools: Audacity, ffmpeg

2. **Normalize Volume**
   - Ensure consistent volume across all files
   - Target: -3dB to -1dB peak

3. **Apply Fade In/Out**
   - Short fade (50-100ms) prevents clicks

**Using ffmpeg (command line):**
```bash
# Trim silence
ffmpeg -i input.mp3 -af "silenceremove=1:0:-50dB:1:5:-50dB" output.mp3

# Normalize volume
ffmpeg -i input.mp3 -af "loudnorm" output.mp3

# Add fade in/out
ffmpeg -i input.mp3 -af "afade=t=in:st=0:d=0.1,afade=t=out:st=2:d=0.1" output.mp3
```

---

## 🔄 Alternative Methods

### Method 1: Use System Sounds

Copy built-in system notification sounds:

**macOS:**
```bash
cp /System/Library/Sounds/Glass.aiff ~/Downloads/notification.aiff
# Convert to MP3 using online converter or ffmpeg
```

**Windows:**
```powershell
# Browse to C:\Windows\Media\
# Copy .wav files and convert to MP3
```

**Linux:**
```bash
cp /usr/share/sounds/freedesktop/stereo/complete.oga ~/Downloads/
# Convert to MP3
```

### Method 2: Free TTS Services

**Google Cloud TTS:**
- Free tier: 1 million characters/month
- High quality
- Multiple languages

**Microsoft Azure TTS:**
- Free tier: 500,000 characters/month
- Natural voices

**Online TTS Generators:**
- [TTSMaker](https://ttsmaker.com/) - Free, no signup
- [Natural Reader](https://www.naturalreaders.com/online/) - Free tier
- [Wideo](https://text-to-speech-demo.ng.bluemix.net/) - IBM Watson

### Method 3: Record Your Own Voice

Use your smartphone or computer:

1. **Record** using Voice Memos (iOS) or Voice Recorder (Android/Windows)
2. **Export** as audio file
3. **Convert to MP3** if needed
4. **Edit** to trim and normalize

**Pros:**
- Completely personalized
- Free
- Unique

**Cons:**
- Quality depends on equipment
- May sound less professional

### Method 4: Royalty-Free Sound Effects

Download from:
- [Freesound.org](https://freesound.org/) - Large library, requires attribution
- [Zapsplat](https://www.zapsplat.com/) - Free with attribution
- [Notification Sounds](https://notificationsounds.com/) - Free, no attribution

Search terms:
- "notification"
- "alert"
- "beep"
- "complete"
- "chime"

---

## 📏 Audio File Specifications

### Technical Requirements

| Specification | Requirement | Why |
|---------------|-------------|-----|
| **Format** | MP3 | Universal compatibility |
| **Sample Rate** | 44.1 kHz | Standard audio quality |
| **Bit Rate** | 128 kbps | Good balance of quality/size |
| **Channels** | Mono or Stereo | Both work fine |
| **Duration** | 1-3 seconds | Short enough to not be annoying |
| **File Size** | < 100 KB | Fast loading |
| **Peak Volume** | -3dB to -1dB | Loud enough but not clipping |

### Converting Audio Files

**To MP3 using ffmpeg:**
```bash
ffmpeg -i input.wav -codec:a libmp3lame -qscale:a 2 output.mp3
```

**Batch convert multiple files:**
```bash
for file in *.wav; do
    ffmpeg -i "$file" -codec:a libmp3lame -qscale:a 2 "${file%.wav}.mp3"
done
```

---

## 💾 Installation and Replacement

### Installing Your Audio Files

1. **Place files in the correct directory:**
   ```bash
   cp your-audio-file.mp3 ~/claude-code-audio-hooks/audio/default/notification-urgent.mp3
   ```

2. **Or use custom directory:**
   ```bash
   cp your-audio-file.mp3 ~/claude-code-audio-hooks/audio/custom/my-notification.mp3
   ```

3. **Update configuration** (if using custom):
   Edit `config/user_preferences.json`:
   ```json
   {
     "audio_files": {
       "notification": "custom/my-notification.mp3"
     }
   }
   ```

### Testing Audio Files

```bash
# Test all audio files
cd ~/claude-code-audio-hooks
./scripts/test-audio.sh

# Test specific file
bash hooks/shared/hook_config.sh
# Then in another terminal:
python3 -c "from hooks.shared.hook_config import test_audio_playback; test_audio_playback('audio/default/notification-urgent.mp3')"
```

### Placeholder Files

If you're not ready to create all audio files immediately:

1. **Use existing audio** as placeholder:
   ```bash
   cd ~/claude-code-audio-hooks/audio/default
   for file in notification-urgent.mp3 notification-info.mp3 task-starting.mp3 task-progress.mp3 prompt-received.mp3 subagent-complete.mp3 session-start.mp3 session-end.mp3; do
       cp task-complete.mp3 "$file"
   done
   ```

2. **Create empty files** (hooks will skip them):
   ```bash
   touch ~/claude-code-audio-hooks/audio/default/{notification-urgent,task-starting}.mp3
   ```

---

## 💡 Tips for Great Notifications

### Do's ✅

1. **Keep it Short:** 1-3 seconds is ideal
2. **Make it Pleasant:** You'll hear these often!
3. **Test Volume:** Ensure it's noticeable but not jarring
4. **Use Consistent Voice:** Same voice/style across all notifications
5. **Add Variety:** Different tones for different urgencies
6. **Test in Context:** Try them while actually working
7. **Consider Your Environment:** Adjust for home office vs. open office

### Don'ts ❌

1. **Don't Use Loud/Jarring Sounds:** You'll get annoyed quickly
2. **Don't Make Them Too Long:** >5 seconds becomes intrusive
3. **Don't Use Copyrighted Material:** Stick to original or licensed sounds
4. **Don't Use Same Sound for Everything:** Defeats the purpose
5. **Don't Over-Engineer:** Simple often works best
6. **Don't Forget to Normalize:** Inconsistent volumes are annoying

### Recommended Approach

**For Most Users:**
1. Start with 3 files: urgent, complete, and info
2. Use ElevenLabs for quick, professional results
3. Keep the same voice for consistency
4. Vary only the message and tone

**For Power Users:**
1. Create all 9 files
2. Use different tones for different urgencies
3. Apply audio effects (reverb, eq) for distinction
4. Test extensively in real usage

**For Minimalists:**
1. Use simple beeps/chimes
2. Download from free sound libraries
3. Distinguish by pitch/duration only

---

## 🎨 Example Audio Profiles

### Profile 1: Professional

| File | Text | Voice | Duration |
|------|------|-------|----------|
| notification-urgent | "Your confirmation is required" | Adam | 2.5s |
| task-complete | "Task complete" | Adam | 2s |
| subagent-complete | "Agent finished" | Adam | 1.8s |

**Character:** Professional, clear, business-appropriate

### Profile 2: Friendly

| File | Text | Duration |
|------|------|----------|
| notification-urgent | "Hey! I need your help" | Antoni | 2s |
| task-complete | "Done!" | Antoni | 1.5s |
| subagent-complete | "All set!" | Antoni | 1.5s |

**Character:** Warm, friendly, casual

### Profile 3: Minimal

| File | Type | Duration |
|------|------|----------|
| notification-urgent | High-pitched beep | 0.5s |
| task-complete | Medium-pitched chime | 1s |
| subagent-complete | Low-pitched beep | 0.8s |

**Character:** Non-verbal, unobtrusive

---

## 📚 Resources

### TTS Services
- [ElevenLabs](https://elevenlabs.io) - Best quality, free tier available
- [Google Cloud TTS](https://cloud.google.com/text-to-speech) - Enterprise quality
- [Azure TTS](https://azure.microsoft.com/en-us/services/cognitive-services/text-to-speech/) - Natural voices

### Sound Libraries
- [Freesound](https://freesound.org/) - Community sounds
- [Zapsplat](https://www.zapsplat.com/) - Professional SFX
- [Notification Sounds](https://notificationsounds.com/) - Dedicated to notifications

### Audio Editing Tools
- [Audacity](https://www.audacityteam.org/) - Free, cross-platform
- [ffmpeg](https://ffmpeg.org/) - Command-line powerhouse
- [Ocenaudio](https://www.ocenaudio.com/) - Simple, fast editor

### Online Converters
- [Online Audio Converter](https://online-audio-converter.com/)
- [CloudConvert](https://cloudconvert.com/)
- [Convertio](https://convertio.co/)

---

## 🤝 Sharing Your Audio Files

Created great notification sounds? Share them with the community!

1. **Ensure Rights:** Make sure you have rights to share
2. **Package Them:** Create a zip file with all audio files
3. **Create an Issue:** On GitHub, share your audio pack
4. **Include Details:** Voice used, TTS service, any modifications

**Community Audio Packs:** Coming soon!

---

## 🔧 Troubleshooting

### Audio Files Not Playing

1. **Check file format:** Must be MP3
2. **Check file location:** Must be in `audio/default/` or `audio/custom/`
3. **Check file size:** Should be > 0 bytes
4. **Test playback manually:** Run test-audio.sh
5. **Check configuration:** Verify paths in user_preferences.json

### Audio Quality Issues

1. **Clipping:** Reduce volume/normalize
2. **Muffled:** Check sample rate (should be 44.1kHz)
3. **Clicks/Pops:** Add fade in/out
4. **Too Quiet:** Normalize to higher level

### Volume Inconsistencies

All files should be normalized to same level:
```bash
ffmpeg -i input.mp3 -af loudnorm=I=-16:LRA=11:TP=-1.5 output.mp3
```

---

## 📞 Need Help?

- **Documentation:** Check the main README.md
- **Issues:** [GitHub Issues](https://github.com/ChanMeng666/claude-code-audio-hooks/issues)
- **Discussions:** [GitHub Discussions](https://github.com/ChanMeng666/claude-code-audio-hooks/discussions)

---

Made with ❤️ for the Claude Code community
