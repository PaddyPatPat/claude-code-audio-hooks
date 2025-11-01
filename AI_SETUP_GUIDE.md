# AI-Assisted Installation Guide 🤖

> **✨ Zero Learning Curve Installation** - Let ANY AI tool automatically install and configure Claude Code Audio Hooks for you. Users don't need to read any documentation - AI reads and installs everything!

**Version 2.0.0** - Complete multi-hook audio notification system with professional ElevenLabs voice recordings.

---

## 🎯 For Users: One-Line Installation Prompt

**Copy this single line to ANY AI assistant (Claude Code, Cursor, Copilot, ChatGPT, etc.):**

```
Please install Claude Code Audio Hooks version 2.0 from https://github.com/ChanMeng666/claude-code-audio-hooks and configure it for me. This adds 9 types of audio notifications to Claude Code. See the AI_SETUP_GUIDE.md in the repo for complete instructions.
```

**That's it!** Your AI will automatically:
- ✅ Verify Claude Code is installed
- ✅ Clone the repository
- ✅ Run the installer (handles all 9 hooks)
- ✅ Configure everything automatically
- ✅ Test all audio notifications
- ✅ Help troubleshoot if needed
- ✅ Guide you through customization

**No reading required. No manual steps. Just paste and let AI work!**

---

## 🎉 What's New in v2.0.0

### **9 Audio Hooks** (Up from 1 in v1.0)

1. **⚠️ Notification** - Authorization/confirmation requests (NEW!)
2. **✅ Stop** - Task completion (enhanced from v1.0)
3. **🔨 PreToolUse** - Before tool execution (NEW!)
4. **📊 PostToolUse** - After tool execution (NEW!)
5. **💬 UserPromptSubmit** - Prompt submission (NEW!)
6. **🤖 SubagentStop** - Background task completion (NEW!)
7. **🗜️ PreCompact** - Before conversation compaction (NEW!)
8. **👋 SessionStart** - Session starts (NEW!)
9. **👋 SessionEnd** - Session ends (NEW!)

### **Professional Audio Files**

All 9 audio files are **professional ElevenLabs Jessica voice recordings** - ready to use immediately!
- notification-urgent.mp3 - "Attention! Claude needs your authorization."
- task-complete.mp3 - "Task completed successfully!"
- subagent-complete.mp3 - "Background task finished!"
- And 6 more professional recordings...

### **Configuration System**

- Interactive configuration tool (`scripts/configure.sh`)
- Enable/disable hooks individually
- Customize audio files per hook type
- Queue system prevents overlapping sounds
- Debounce system prevents notification spam

### **Automatic v1.0 Upgrade**

If user has v1.0 installed, the installer automatically:
- Detects old installation
- Backs up custom audio
- Migrates to v2.0
- Preserves user customizations

---

## 🤖 AI Installation Prompt (Detailed Version)

**For AI assistants: Copy everything below and paste to your AI tool:**

```
I need you to install and configure Claude Code Audio Hooks v2.0 for me.

PROJECT INFORMATION:
- Repository: https://github.com/ChanMeng666/claude-code-audio-hooks
- Version: 2.0.0
- What it does: Adds 9 types of audio notifications to Claude Code CLI
- Platform support: Windows (WSL), Linux, macOS
- Audio files: 9 professional ElevenLabs Jessica voice recordings (included)
- Zero manual configuration needed - everything is automated

PREREQUISITES TO CHECK:
1. Claude Code must be installed (run: claude --version)
   - If not installed: Direct me to https://claude.ai/download
2. Git must be installed (usually pre-installed)
3. Python 3 must be installed (for configuration management)

INSTALLATION STEPS (Execute for me):

1. Verify prerequisites:
   claude --version
   git --version
   python3 --version

2. Navigate to home directory and clone repository:
   cd ~
   git clone https://github.com/ChanMeng666/claude-code-audio-hooks.git
   cd claude-code-audio-hooks

3. Check if v1.0 is installed (installer will auto-upgrade):
   ls -la ~/.claude/hooks/play_audio.sh

4. Run the automated installer:
   bash scripts/install.sh

   The installer will:
   - Detect and upgrade v1.0 if present
   - Install all 9 hook scripts to ~/.claude/hooks/
   - Install shared configuration library
   - Update settings.json with all 9 hooks
   - Update settings.local.json with permissions
   - Create configuration files
   - Create backups of all changes

5. Verify installation succeeded:
   bash scripts/check-setup.sh

   This runs 12 comprehensive checks. All should pass (warnings are OK).

6. Test audio notifications:
   bash scripts/test-audio.sh

   Follow the interactive menu to test audio playback.

7. Show configuration options:
   bash scripts/configure.sh

   This allows enabling/disabling specific hooks.

8. Remind me to restart Claude Code for changes to take effect.

POST-INSTALLATION:
- Explain the 9 hook types and which are enabled by default
- Default enabled: Notification, Stop, SubagentStop (3 of 9)
- Offer to help customize which hooks are enabled
- Offer to help create custom audio files if desired
- Remind that all audio files are professional recordings

TROUBLESHOOTING (if anything fails):
- Check output of scripts/check-setup.sh for specific issues
- Verify ~/.claude/ directory exists
- Check that scripts/ directory has all utility scripts
- Verify audio files exist in audio/default/ directory
- For WSL: Verify PowerShell is accessible
- For Linux: May need to install mpg123
- For macOS: Verify afplay is available

Please execute all these steps and provide status updates as you go.
```

---

## 🎓 For AI Assistants: Technical Implementation Guide

### Overview

Claude Code Audio Hooks v2.0 is a **modular multi-hook system** with:
- **9 hook scripts** (one per Claude Code hook event)
- **Shared configuration library** (580 lines - audio playback, queue, debounce, config management)
- **Configuration system** (JSON-based user preferences)
- **Professional audio files** (9 ElevenLabs Jessica voice MP3s)
- **Utility scripts** (install, upgrade, configure, test, verify, uninstall)

### Architecture

```
claude-code-audio-hooks/
├── hooks/
│   ├── notification_hook.sh        # ⚠️ Authorization alerts
│   ├── stop_hook.sh                 # ✅ Task completion
│   ├── pretooluse_hook.sh           # 🔨 Before tools
│   ├── posttooluse_hook.sh          # 📊 After tools
│   ├── userprompt_hook.sh           # 💬 Prompt submission
│   ├── subagent_hook.sh             # 🤖 Subagent completion
│   ├── precompact_hook.sh           # 🗜️ Before compaction
│   ├── session_start_hook.sh        # 👋 Session start
│   ├── session_end_hook.sh          # 👋 Session end
│   └── shared/
│       └── hook_config.sh           # Shared library (580 lines)
├── audio/
│   ├── default/                     # 9 professional ElevenLabs MP3s
│   ├── custom/                      # User custom audio (optional)
│   └── README.md                    # Audio usage guide
├── config/
│   ├── default_preferences.json     # Default configuration
│   └── user_preferences.json        # User configuration (created on install)
├── scripts/
│   ├── install.sh                   # Main installer (auto v1.0 upgrade)
│   ├── upgrade.sh                   # Standalone v1.0 → v2.0 migration
│   ├── configure.sh                 # Interactive configuration UI
│   ├── uninstall.sh                 # Complete removal
│   ├── check-setup.sh               # 12-point verification
│   └── test-audio.sh                # Audio testing tool
├── docs/
│   └── AUDIO_CREATION.md            # Comprehensive audio creation guide
└── examples/
    ├── settings.json                # Example Claude Code config
    └── user_preferences.json        # Example user config
```

### Installation Process (Step-by-Step)

#### Step 1: Prerequisites Check

```bash
# Verify Claude Code (REQUIRED)
if ! command -v claude &> /dev/null; then
    echo "ERROR: Claude Code not installed"
    echo "Please install from: https://claude.ai/download"
    exit 1
fi

# Check platform
if grep -qi microsoft /proc/version 2>/dev/null; then
    echo "Platform: WSL (Windows Subsystem for Linux)"
    PLATFORM="wsl"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Platform: macOS"
    PLATFORM="macos"
else
    echo "Platform: Linux"
    PLATFORM="linux"
fi

# Verify Python 3 (needed for JSON config management)
if ! command -v python3 &> /dev/null; then
    echo "WARNING: Python 3 not found (needed for configuration)"
    # Suggest installation based on platform
fi
```

#### Step 2: Clone Repository

```bash
cd ~

# Check if repository already exists
if [ -d "claude-code-audio-hooks" ]; then
    echo "Repository already exists. Updating..."
    cd claude-code-audio-hooks
    git pull origin master
else
    echo "Cloning repository..."
    git clone https://github.com/ChanMeng666/claude-code-audio-hooks.git
    cd claude-code-audio-hooks
fi
```

#### Step 3: Run Installer

```bash
# Make installer executable
chmod +x scripts/install.sh

# Run installer (handles everything automatically)
bash scripts/install.sh
```

**What the installer does:**

1. **Detects v1.0 installation** (if present):
   - Checks for old `~/.claude/hooks/play_audio.sh` without v2.0 markers
   - Offers automatic upgrade
   - Backs up custom audio to `audio/legacy/`
   - Migrates user customizations

2. **Creates directories** (if needed):
   - `~/.claude/hooks/` - Hook scripts
   - `~/.claude/hooks/shared/` - Shared library
   - `audio/custom/` - Custom audio storage
   - `config/` - Configuration files

3. **Installs all 9 hook scripts**:
   - Copies from `hooks/` to `~/.claude/hooks/`
   - Sets executable permissions
   - Installs shared library

4. **Updates Claude Code configuration**:
   - Backs up existing `~/.claude/settings.json`
   - Adds all 9 hook events using Python JSON manipulation
   - Backs up existing `~/.claude/settings.local.json`
   - Adds permissions for all 9 hook scripts

5. **Creates user configuration**:
   - Copies `config/default_preferences.json` → `config/user_preferences.json`
   - Default enabled: notification, stop, subagent_stop
   - Default disabled: pretooluse, posttooluse, userpromptsubmit, precompact, session_start, session_end

6. **Verifies audio files**:
   - Checks all 9 audio files exist in `audio/default/`
   - All files are professional ElevenLabs Jessica voice MP3s

#### Step 4: Verify Installation

```bash
bash scripts/check-setup.sh
```

**12 verification checks:**

1. ✅ Claude Code installed and version detected
2. ✅ `.claude/` configuration directory exists
3. ✅ `.claude/hooks/` directory exists
4. ✅ All 9 hook scripts exist and are executable
5. ✅ Shared library exists and is sourced correctly
6. ✅ Project directory exists at `~/claude-code-audio-hooks`
7. ✅ All 9 audio files exist in `audio/default/`
8. ✅ `settings.json` contains all 9 hook events
9. ✅ `settings.local.json` contains all 9 permissions
10. ✅ Configuration files exist (`user_preferences.json`)
11. ✅ Audio playback capability detected (WSL/Linux/macOS)
12. ✅ Platform-specific audio player available

**Output:**
- **Green checkmarks (✓)**: Passed
- **Yellow warnings (⚠)**: Non-critical issues
- **Red X (✗)**: Failed - must fix

#### Step 5: Test Audio

```bash
bash scripts/test-audio.sh
```

**Interactive menu options:**
1. Test all enabled hooks (recommended)
2. Test ALL audio files (including disabled)
3. Test specific hook
4. Quick test (task-complete only)

**Expected behavior:**
- Plays each audio file with 2-second gaps
- Shows file information (name, size, description)
- Provides troubleshooting if audio doesn't play

#### Step 6: Configure (Optional)

```bash
bash scripts/configure.sh
```

**Interactive configuration tool:**
- Shows all 9 hooks with current status [✓] or [ ]
- Toggle individual hooks on/off
- Test audio for each hook
- Reset to defaults
- Save configuration

**Default configuration:**
- ✅ Enabled: notification, stop, subagent_stop (3 of 9)
- ❌ Disabled: pretooluse, posttooluse, userpromptsubmit, precompact, session_start, session_end

**Why these defaults?**
- **notification**: Critical - alerts for authorization/confirmation (RECOMMENDED)
- **stop**: Essential - task completion notification (RECOMMENDED)
- **subagent_stop**: Important - background task alerts (RECOMMENDED)
- **pretooluse**: Noisy - fires before EVERY tool (use sparingly)
- **posttooluse**: Very noisy - fires after EVERY tool (debugging only)
- **userpromptsubmit**: Optional - confirms prompt submission
- **precompact**: Rare - fires before conversation compaction
- **session_start/end**: Optional - session boundary notifications

#### Step 7: Remind User

```
IMPORTANT: Please restart Claude Code for changes to take effect!

Just close your Claude Code terminal and open it again. The audio
notifications will then work automatically.

You can test it with any Claude command:
  claude "What is 2+2?"

When Claude finishes, you'll hear a notification sound! 🎉
```

### Expected File Locations After Installation

```
~/.claude/
├── hooks/
│   ├── notification_hook.sh        # Installed ✓
│   ├── stop_hook.sh                 # Installed ✓
│   ├── pretooluse_hook.sh           # Installed ✓
│   ├── posttooluse_hook.sh          # Installed ✓
│   ├── userprompt_hook.sh           # Installed ✓
│   ├── subagent_hook.sh             # Installed ✓
│   ├── precompact_hook.sh           # Installed ✓
│   ├── session_start_hook.sh        # Installed ✓
│   ├── session_end_hook.sh          # Installed ✓
│   └── shared/
│       └── hook_config.sh           # Installed ✓ (580 lines)
├── settings.json                    # Updated with 9 hooks ✓
├── settings.local.json              # Updated with 9 permissions ✓
└── settings.json.backup             # Backup created ✓

~/claude-code-audio-hooks/
├── config/
│   ├── default_preferences.json     # Template
│   └── user_preferences.json        # User config ✓ (created on install)
└── audio/
    ├── default/                     # 9 professional ElevenLabs MP3s ✓
    │   ├── notification-urgent.mp3
    │   ├── task-complete.mp3
    │   ├── task-starting.mp3
    │   ├── task-progress.mp3
    │   ├── prompt-received.mp3
    │   ├── subagent-complete.mp3
    │   ├── notification-info.mp3
    │   ├── session-start.mp3
    │   └── session-end.mp3
    └── custom/                      # User custom audio (empty initially)
```

### Troubleshooting Guide for AI Assistants

#### Issue 1: Claude Code Not Installed

**Symptoms:**
```
bash: claude: command not found
```

**Resolution:**
```
Claude Code is not installed. Please install it first:
1. Visit: https://claude.ai/download
2. Download and install Claude Code CLI for your platform
3. Verify installation: claude --version
4. Then run the installer again
```

#### Issue 2: Python 3 Not Found

**Symptoms:**
```
bash: python3: command not found
```

**Resolution:**
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install python3

# macOS
brew install python3

# Verify
python3 --version
```

#### Issue 3: Git Not Found

**Symptoms:**
```
bash: git: command not found
```

**Resolution:**
```bash
# Ubuntu/Debian
sudo apt-get install git

# macOS
brew install git
```

#### Issue 4: Installation Failed with Permission Errors

**Symptoms:**
```
Permission denied: ~/.claude/settings.json
```

**Resolution:**
```bash
# Check Claude directory permissions
ls -la ~/.claude/

# Fix permissions if needed
chmod 755 ~/.claude/
chmod 644 ~/.claude/settings.json
chmod 644 ~/.claude/settings.local.json

# Re-run installer
bash scripts/install.sh
```

#### Issue 5: Audio Not Playing

**For WSL:**
```bash
# Verify PowerShell is accessible
powershell.exe -Command "Write-Host 'PowerShell works'"

# Test audio manually
cd ~/claude-code-audio-hooks
bash scripts/test-audio.sh
```

**For Linux:**
```bash
# Install audio player
sudo apt-get install mpg123

# Test audio
mpg123 ~/claude-code-audio-hooks/audio/default/task-complete.mp3
```

**For macOS:**
```bash
# Verify afplay (built-in)
which afplay

# Test audio
afplay ~/claude-code-audio-hooks/audio/default/task-complete.mp3
```

#### Issue 6: Hooks Not Triggering

**Symptoms:**
- Installation succeeded
- Audio files exist
- But no sound plays when Claude finishes

**Resolution:**
```
1. Verify user restarted Claude Code (REQUIRED!)
2. Check settings.json contains all 9 hooks:
   cat ~/.claude/settings.json | grep -A 5 "Notification"
3. Check settings.local.json has permissions:
   cat ~/.claude/settings.local.json | grep "notification_hook"
4. Verify hook script is executable:
   ls -la ~/.claude/hooks/notification_hook.sh
5. Run check-setup.sh for detailed diagnostics:
   bash scripts/check-setup.sh
```

#### Issue 7: v1.0 Already Installed

**Symptoms:**
```
Found existing v1.0 installation
```

**Resolution:**
```
The installer will automatically upgrade from v1.0 to v2.0!

What it does:
- Backs up your custom audio to audio/legacy/
- Removes old single hook
- Installs new 9-hook system
- Preserves your customizations
- Migrates settings

Just follow the installer prompts. It handles everything automatically!
```

### Platform-Specific Notes

#### Windows (WSL)

**Audio Playback:**
- Uses PowerShell's `System.Windows.Media.MediaPlayer`
- Requires PowerShell.exe accessible from WSL
- Works out of the box (no additional setup)

**Path Handling:**
- Hook converts Linux paths to Windows paths using `wslpath -w`
- Audio files must be in WSL filesystem

#### Linux (Native)

**Audio Playback:**
- Default uses PowerShell (designed for WSL)
- For native Linux, install `mpg123`:
  ```bash
  sudo apt-get install mpg123
  ```
- Or use `aplay` for WAV files (ALSA utils):
  ```bash
  sudo apt-get install alsa-utils
  ```

**Note:** Installer detects native Linux and provides instructions

#### macOS

**Audio Playback:**
- Uses built-in `afplay` command
- No additional installation needed
- Works with all macOS audio formats

**Note:** Installer detects macOS and configures correctly

### Advanced Customization

#### Custom Audio Files

Users can replace any of the 9 audio files:

```bash
# Replace specific audio file
cp /path/to/custom.mp3 ~/claude-code-audio-hooks/audio/custom/my-notification.mp3

# Update configuration to use custom audio
bash scripts/configure.sh
# Or edit config/user_preferences.json manually
```

#### Creating Custom Audio with ElevenLabs

For users wanting personalized notifications:

1. Visit https://elevenlabs.io
2. Use Text-to-Speech feature
3. Choose voice preset (Jessica is current default)
4. Generate audio for each notification type:
   - "Attention! Claude needs your authorization."
   - "Task completed successfully!"
   - "Background task finished!"
   - etc.
5. Download MP3 files
6. Copy to `audio/custom/` directory
7. Update `config/user_preferences.json` audio_files section

**See `docs/AUDIO_CREATION.md` for comprehensive guide (40KB)**

### Configuration File Format

**config/user_preferences.json:**

```json
{
  "version": "2.0.0",
  "enabled_hooks": {
    "notification": true,      // Authorization alerts (RECOMMENDED)
    "stop": true,             // Task completion (RECOMMENDED)
    "pretooluse": false,      // Before tool execution (noisy)
    "posttooluse": false,     // After tool execution (very noisy)
    "userpromptsubmit": false, // Prompt submission
    "subagent_stop": true,    // Subagent completion (RECOMMENDED)
    "precompact": false,      // Before compaction (rare)
    "session_start": false,   // Session start
    "session_end": false      // Session end
  },
  "audio_files": {
    "notification": "default/notification-urgent.mp3",
    "stop": "default/task-complete.mp3",
    "pretooluse": "default/task-starting.mp3",
    "posttooluse": "default/task-progress.mp3",
    "userpromptsubmit": "default/prompt-received.mp3",
    "subagent_stop": "default/subagent-complete.mp3",
    "precompact": "default/notification-info.mp3",
    "session_start": "default/session-start.mp3",
    "session_end": "default/session-end.mp3"
  },
  "playback_settings": {
    "queue_enabled": true,      // Prevent overlapping sounds
    "max_queue_size": 5,        // Max queued notifications
    "debounce_ms": 500          // Min ms between same notification
  }
}
```

### Uninstallation

If user wants to remove the system:

```bash
cd ~/claude-code-audio-hooks
bash scripts/uninstall.sh
```

**Uninstaller will:**
1. Remove all 9 hook scripts from `~/.claude/hooks/`
2. Remove shared library
3. Backup and clean `settings.json`
4. Backup and clean `settings.local.json`
5. Ask about keeping audio files
6. Ask about keeping project folder

**Safe process** - creates backups before any removal!

---

## 🎓 Example: Complete AI Installation Session

**User:** "Install Claude Code Audio Hooks for me"

**AI:** "I'll install Claude Code Audio Hooks v2.0, which adds 9 types of audio notifications to Claude Code. Let me start by checking your system."

```bash
claude --version
```

**AI:** "Great! Claude Code 1.x.x is installed. Now checking other prerequisites..."

```bash
git --version && python3 --version
```

**AI:** "Perfect! All prerequisites are met. Now I'll clone the repository..."

```bash
cd ~
git clone https://github.com/ChanMeng666/claude-code-audio-hooks.git
cd claude-code-audio-hooks
```

**AI:** "Repository cloned successfully. Now running the automated installer..."

```bash
bash scripts/install.sh
```

**AI (analyzing output):** "The installer has completed successfully! It installed:
- 9 hook scripts for different notification types
- Shared configuration library (580 lines)
- Professional ElevenLabs Jessica voice audio files
- Configuration management system

By default, 3 hooks are enabled:
- ⚠️ Notification - For authorization/confirmation alerts
- ✅ Stop - For task completion
- 🤖 SubagentStop - For background task completion

Let me verify the installation..."

```bash
bash scripts/check-setup.sh
```

**AI (analyzing output):** "Perfect! All 12 verification checks passed:
✓ Claude Code installed
✓ All 9 hook scripts installed and executable
✓ Shared library installed
✓ All 9 audio files present
✓ Configuration files created
✓ settings.json updated
✓ settings.local.json updated
✓ Audio playback system detected (WSL/Linux/macOS)

Now let me test the audio notifications..."

```bash
bash scripts/test-audio.sh
```

**AI:** "I've played the test audio. Did you hear the notification sounds?

**IMPORTANT:** Please restart Claude Code now for the changes to take effect!

Just close your terminal and open it again. After restarting, try any Claude command:

```
claude "What is 2+2?"
```

When Claude finishes responding, you'll hear a pleasant notification sound!

**What you have now:**
- 9 different notification types (3 enabled by default)
- Professional ElevenLabs Jessica voice recordings
- Interactive configuration tool to enable/disable specific hooks
- Custom audio support if you want to personalize

Would you like me to:
1. Show you how to enable/disable specific notification types?
2. Help you create custom audio files with ElevenLabs?
3. Explain what each notification type does?

The installation is complete - just restart Claude Code and you're all set! 🎉"

---

## 📚 Additional Resources

**For AI Assistants:**
- Full user documentation: [README.md](README.md)
- Audio creation guide: [docs/AUDIO_CREATION.md](docs/AUDIO_CREATION.md)
- Version changelog: [CHANGELOG.md](CHANGELOG.md)
- Example configurations: [examples/](examples/)

**For Users:**
- GitHub repository: https://github.com/ChanMeng666/claude-code-audio-hooks
- Report issues: https://github.com/ChanMeng666/claude-code-audio-hooks/issues
- Discussions: https://github.com/ChanMeng666/claude-code-audio-hooks/discussions

---

## 🎯 Success Criteria

**Installation is successful when:**

1. ✅ All scripts executed without errors
2. ✅ `scripts/check-setup.sh` shows 12/12 checks passing (warnings OK, no failures)
3. ✅ `scripts/test-audio.sh` plays audio successfully
4. ✅ User confirms they heard the audio
5. ✅ User is reminded to restart Claude Code
6. ✅ User understands which 3 hooks are enabled by default
7. ✅ User knows how to customize (scripts/configure.sh)

---

## 💡 Tips for AI Assistants

1. **Be proactive** - Run all verification automatically
2. **Explain clearly** - Describe what each step does
3. **Handle errors gracefully** - Diagnose and suggest specific solutions
4. **Be platform-aware** - Detect OS and provide platform-specific guidance
5. **Follow up** - Confirm audio played, offer customization help
6. **Emphasize restart** - Users MUST restart Claude Code for hooks to activate
7. **Explain defaults** - 3 of 9 hooks enabled by default (notification, stop, subagent_stop)
8. **Offer customization** - Mention scripts/configure.sh for enabling/disabling hooks
9. **Highlight v2.0 features** - 9 hooks, professional audio, configuration system
10. **Zero learning curve** - User shouldn't need to read anything!

---

## 🚀 Quick Command Reference

**Single-line installation:**
```bash
cd ~ && git clone https://github.com/ChanMeng666/claude-code-audio-hooks.git && cd claude-code-audio-hooks && bash scripts/install.sh && bash scripts/check-setup.sh
```

**Verification only:**
```bash
cd ~/claude-code-audio-hooks && bash scripts/check-setup.sh
```

**Test audio:**
```bash
cd ~/claude-code-audio-hooks && bash scripts/test-audio.sh
```

**Configure hooks:**
```bash
cd ~/claude-code-audio-hooks && bash scripts/configure.sh
```

**Upgrade from v1.0:**
```bash
cd ~/claude-code-audio-hooks && git pull && bash scripts/install.sh
```

**Uninstall:**
```bash
cd ~/claude-code-audio-hooks && bash scripts/uninstall.sh
```

---

<div align="center">

**🎯 This guide enables ANY AI tool to automatically install Claude Code Audio Hooks with ZERO learning curve for users.**

**Version 2.0.0** - Complete multi-hook audio notification system

If you're an AI assistant and something isn't clear, refer to the full documentation or ask the user to report an issue on GitHub.

**Made with ❤️ for the Claude Code community**

</div>
