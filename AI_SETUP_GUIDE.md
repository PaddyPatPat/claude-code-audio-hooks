# AI-Assisted Installation Guide 🤖

> **Let AI tools do the work for you!** This guide is designed for AI assistants like Claude Code, Cursor, GitHub Copilot, Gemini CLI, and other AI-powered development tools to automatically install and configure Claude Code Audio Hooks.

---

## 🎯 For Users: How to Use This Guide

If you're using an AI-powered coding tool, you can simply copy the [AI Installation Prompt](#ai-installation-prompt) below and paste it into your AI assistant. The AI will automatically:

1. ✅ Check if Claude Code is installed
2. ✅ Clone this repository
3. ✅ Run the installation script
4. ✅ Verify the setup
5. ✅ Test the audio notification
6. ✅ Help you customize if needed

### Supported AI Tools:

- **Claude Code** - Anthropic's AI coding assistant
- **Cursor** - AI-first code editor
- **GitHub Copilot CLI** - GitHub's AI command line tool
- **Gemini CLI** - Google's AI assistant
- **Cody** - Sourcegraph's AI coding assistant
- **Aider** - AI pair programming in your terminal
- **ChatGPT (with code execution)** - OpenAI's assistant
- Any other AI tool with command execution capabilities

---

## 🤖 AI Installation Prompt

**Users: Copy everything in the box below and paste it to your AI assistant:**

```
I need you to help me install Claude Code Audio Hooks, a tool that plays audio notifications when Claude Code finishes responding.

CONTEXT:
- Repository: https://github.com/ChanMeng666/claude-code-audio-hooks
- This adds audio notifications to Claude Code CLI
- Works on Windows (WSL), Linux, and macOS (with modifications)
- Requires: Claude Code CLI already installed

INSTALLATION STEPS - Please execute these for me:

1. First, verify Claude Code is installed:
   - Run: claude --version
   - If not installed, inform me and provide the download link: https://claude.ai/download

2. Clone the repository to my home directory:
   - cd ~
   - git clone https://github.com/ChanMeng666/claude-code-audio-hooks.git
   - cd claude-code-audio-hooks

3. Make the installation script executable and run it:
   - chmod +x install.sh
   - ./install.sh

4. After installation, run the verification script:
   - chmod +x check-setup.sh
   - ./check-setup.sh

5. Test the audio notification:
   - chmod +x test-audio.sh
   - ./test-audio.sh

6. Inform me that I need to restart Claude Code for the changes to take effect.

IMPORTANT NOTES FOR YOU (AI):
- If any command fails, explain what went wrong and suggest solutions
- Check the output of check-setup.sh and help fix any issues
- If the user is on macOS, inform them they need to modify hooks/play_audio.sh to use 'afplay' instead of PowerShell
- If the user is on native Linux (not WSL), inform them they may need to install mpg123 for audio playback

After completing these steps, ask me if I heard the audio notification and if I need help customizing the sound.
```

---

## 📋 For AI Assistants: Technical Implementation Details

If you're an AI assistant processing this installation request, here's what you need to know:

### Prerequisites Check

```bash
# Check if Claude Code is installed
claude --version

# Check OS type
uname -a

# For WSL detection
cat /proc/version | grep -i microsoft
```

### Installation Commands (Execute in Order)

```bash
# 1. Navigate to home directory
cd ~

# 2. Clone repository (check if it already exists first)
if [ -d "claude-code-audio-hooks" ]; then
    echo "Repository already exists. Updating..."
    cd claude-code-audio-hooks
    git pull
else
    git clone https://github.com/ChanMeng666/claude-code-audio-hooks.git
    cd claude-code-audio-hooks
fi

# 3. Run installer
chmod +x install.sh
./install.sh

# 4. Verify installation
chmod +x check-setup.sh
./check-setup.sh

# 5. Test audio
chmod +x test-audio.sh
./test-audio.sh
```

### Expected Outcomes

After successful installation:

1. ✅ Hook script exists at: `~/.claude/hooks/play_audio.sh`
2. ✅ Audio file exists at: `~/claude-code-audio-hooks/audio/hey-chan-please-help-me.mp3`
3. ✅ Configuration in: `~/.claude/settings.json` includes the Stop hook
4. ✅ Permission in: `~/.claude/settings.local.json` allows the hook script
5. ✅ `check-setup.sh` shows all checks passing (or with warnings only)

### Troubleshooting Commands

If installation fails, try these diagnostic commands:

```bash
# Check if Claude directory exists
ls -la ~/.claude/

# Check hook script
ls -la ~/.claude/hooks/play_audio.sh

# Check audio file
ls -la ~/claude-code-audio-hooks/audio/hey-chan-please-help-me.mp3

# Check settings
cat ~/.claude/settings.json | grep -A 10 "Stop"

# Check permissions
cat ~/.claude/settings.local.json | grep "play_audio"

# Test audio manually (WSL)
powershell.exe -Command "& {Add-Type -AssemblyName presentationCore; \$player = New-Object System.Windows.Media.MediaPlayer; \$player.Open('$(wslpath -w ~/claude-code-audio-hooks/audio/hey-chan-please-help-me.mp3)'); \$player.Play(); Start-Sleep -Seconds 3}"
```

### Platform-Specific Instructions

**For WSL (Windows Subsystem for Linux):**
- Default configuration works out of the box
- Uses PowerShell for audio playback

**For macOS:**
- User needs to modify `hooks/play_audio.sh`
- Replace PowerShell section with: `afplay "$AUDIO_FILE" &`

**For Native Linux:**
- May need to install audio player: `sudo apt-get install mpg123`
- Modify `hooks/play_audio.sh` to use mpg123 instead of PowerShell

### Common Issues and Solutions

**Issue 1: Permission Denied**
```bash
chmod +x ~/.claude/hooks/play_audio.sh
```

**Issue 2: Python Not Found (install.sh fails)**
```bash
# Ubuntu/Debian
sudo apt-get install python3

# macOS
brew install python3
```

**Issue 3: Git Not Found**
```bash
# Ubuntu/Debian
sudo apt-get install git

# macOS
brew install git
```

**Issue 4: Audio Not Playing**
- Check system volume
- Verify audio file exists
- For WSL: Verify PowerShell is accessible
- For Linux: Install mpg123
- For macOS: Verify afplay is available (should be built-in)

### Post-Installation

After installation completes:

1. **Remind user to restart Claude Code**
2. **Suggest testing with a simple Claude command**
3. **Offer to help with custom audio creation**
4. **Provide link to full documentation if needed**

### Customization Options

**To replace the audio file:**

```bash
# User provides their own MP3
cp /path/to/custom-audio.mp3 ~/claude-code-audio-hooks/audio/hey-chan-please-help-me.mp3
```

**To create custom audio with ElevenLabs:**
1. Visit https://elevenlabs.io
2. Use Text-to-Speech feature
3. Download MP3
4. Replace the audio file as shown above

---

## 🎓 Example Interaction: AI Assistant Helping User

**User:** "Can you install Claude Code Audio Hooks for me?"

**AI Assistant:** "Of course! I'll install Claude Code Audio Hooks, which will play audio notifications when Claude finishes responding. Let me start by checking your system."

```bash
claude --version
```

**AI:** "Great! I see Claude Code is installed. Now I'll clone the repository and install it for you."

```bash
cd ~
git clone https://github.com/ChanMeng666/claude-code-audio-hooks.git
cd claude-code-audio-hooks
chmod +x install.sh
./install.sh
```

**AI:** "The installation completed successfully! Let me verify everything is set up correctly."

```bash
./check-setup.sh
```

**AI:** "Perfect! All checks passed. Let me test the audio notification for you."

```bash
./test-audio.sh
```

**AI:** "The audio should have played. Did you hear it?

**Important:** Please restart Claude Code for the changes to take effect. Just close and reopen your terminal, then the audio notifications will work automatically!

Would you like me to help you create a custom notification sound using ElevenLabs?"

---

## 🔄 Updating the Installation

**For AI assistants: If user wants to update:**

```bash
cd ~/claude-code-audio-hooks
git pull origin master
./install.sh
```

---

## 🗑️ Uninstalling

**For AI assistants: If user wants to remove:**

```bash
cd ~/claude-code-audio-hooks
./uninstall.sh
```

The uninstaller will prompt the user about keeping certain files.

---

## 📚 Additional Resources for AI Assistants

When helping users, you can reference:

- **Full Documentation:** [README.md](README.md)
- **Quick Start:** [QUICKSTART.md](QUICKSTART.md)
- **Setup Verification:** Run `check-setup.sh`
- **Audio Testing:** Run `test-audio.sh`
- **GitHub Issues:** https://github.com/ChanMeng666/claude-code-audio-hooks/issues
- **Discussions:** https://github.com/ChanMeng666/claude-code-audio-hooks/discussions

---

## 🎯 Success Criteria

The installation is successful when:

1. ✅ All scripts executed without errors
2. ✅ `check-setup.sh` shows all checks passing (or only warnings, no failures)
3. ✅ `test-audio.sh` plays audio successfully
4. ✅ User confirms they heard the audio notification
5. ✅ User is reminded to restart Claude Code

---

## 💡 Tips for AI Assistants

1. **Be proactive:** Run all verification steps automatically
2. **Explain each step:** Help users understand what's happening
3. **Handle errors gracefully:** If something fails, diagnose and suggest solutions
4. **Be platform-aware:** Detect the OS and provide platform-specific guidance
5. **Follow up:** Ask if the user heard the audio, offer customization help
6. **Provide context:** Explain why restarting Claude Code is necessary
7. **Offer alternatives:** If standard installation fails, suggest manual steps

---

## 🚀 Quick Command Reference for AI Tools

**Single-line installation (for quick execution):**

```bash
cd ~ && git clone https://github.com/ChanMeng666/claude-code-audio-hooks.git && cd claude-code-audio-hooks && chmod +x install.sh && ./install.sh && chmod +x check-setup.sh && ./check-setup.sh
```

**Verification only:**

```bash
cd ~/claude-code-audio-hooks && ./check-setup.sh
```

**Test audio only:**

```bash
cd ~/claude-code-audio-hooks && ./test-audio.sh
```

---

<div align="center">

**This guide is optimized for AI assistants to provide seamless installation support.**

If you're an AI assistant and something isn't clear, please refer to the full documentation or ask the user to report an issue on GitHub.

</div>
