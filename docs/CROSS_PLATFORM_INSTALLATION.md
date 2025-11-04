# Cross-Platform Installation Guide

This guide provides detailed installation instructions for Claude Code Audio Hooks across different operating systems and environments.

## Table of Contents

- [Windows](#windows)
  - [PowerShell](#powershell)
  - [Git Bash](#git-bash)
  - [WSL (Windows Subsystem for Linux)](#wsl-windows-subsystem-for-linux)
  - [Cygwin](#cygwin)
- [macOS](#macos)
- [Linux](#linux)
- [Common Issues and Solutions](#common-issues-and-solutions)
- [Platform-Specific Notes](#platform-specific-notes)

---

## Windows

Windows users can install Claude Code Audio Hooks in several environments. Choose the one that matches your setup:

### PowerShell

**Note:** PowerShell native support is limited. We recommend using **Git Bash** or **WSL** for the best experience.

If you must use PowerShell:

1. Install Git Bash from https://git-scm.com/download/win (recommended for better compatibility)
2. Follow the [Git Bash](#git-bash) instructions below

**Why Git Bash is recommended:**
- The installation scripts are written in Bash
- Better Unix tool compatibility
- Easier path handling

### Git Bash

Git Bash is the **recommended** environment for Windows users.

#### Prerequisites

1. **Install Git for Windows** (includes Git Bash):
   ```bash
   # Download from: https://git-scm.com/download/win
   # Or use winget:
   winget install Git.Git
   ```

2. **Install Claude Code** (if not already installed):
   ```bash
   # Follow instructions at: https://docs.claude.com/claude-code
   ```

#### Installation Steps

1. **Clone the repository** (can be anywhere):
   ```bash
   # Clone to any location - examples:
   cd D:/github_repository
   git clone https://github.com/ChanMeng666/claude-code-audio-hooks.git

   # OR clone to home directory:
   cd ~
   git clone https://github.com/ChanMeng666/claude-code-audio-hooks.git
   ```

2. **Run the installer**:
   ```bash
   cd claude-code-audio-hooks
   bash scripts/install.sh
   ```

3. **Verify installation**:
   ```bash
   bash scripts/verify-path-detection.sh
   ```

4. **Test audio playback**:
   ```bash
   bash scripts/test-audio.sh
   # Select option 4 for quick test
   ```

5. **Restart Claude Code** (IMPORTANT):
   - Close all Claude Code windows
   - Reopen Claude Code in Git Bash
   - Try a simple command: `claude "What is 2+2?"`
   - You should hear audio when it completes!

#### Git Bash Specific Notes

- **Audio Playback**: Uses PowerShell.exe to play audio files
- **Path Conversion**: Automatically converts Unix paths (e.g., `/c/Users/...`) to Windows paths (e.g., `C:\Users\...`)
- **Project Location**: Can be installed anywhere - the installer records the path automatically

#### Common Git Bash Issues

**Issue: "bash: scripts/install.sh: No such file or directory"**
```bash
# Make sure you're in the project directory
cd claude-code-audio-hooks
pwd  # Should show the project path
ls scripts/install.sh  # Should show the file
```

**Issue: "Permission denied"**
```bash
chmod +x scripts/install.sh
bash scripts/install.sh
```

**Issue: "Audio not playing"**
```bash
# Check if PowerShell is available
powershell.exe -Command "Write-Host 'PowerShell works'"

# Test audio manually
bash scripts/test-audio.sh
```

---

### WSL (Windows Subsystem for Linux)

WSL provides a Linux environment on Windows with excellent compatibility.

#### Prerequisites

1. **Install WSL 2** (if not already installed):
   ```powershell
   # In PowerShell (as Administrator):
   wsl --install
   ```

2. **Install Ubuntu** (or your preferred distro):
   ```powershell
   wsl --install -d Ubuntu
   ```

3. **Install Claude Code in WSL**:
   ```bash
   # In WSL terminal:
   # Follow: https://docs.claude.com/claude-code
   ```

#### Installation Steps

1. **Clone the repository**:
   ```bash
   cd ~
   git clone https://github.com/ChanMeng666/claude-code-audio-hooks.git
   cd claude-code-audio-hooks
   ```

2. **Run the installer**:
   ```bash
   bash scripts/install.sh
   ```

3. **Verify and test**:
   ```bash
   bash scripts/verify-path-detection.sh
   bash scripts/test-audio.sh
   ```

4. **Restart Claude Code** and test!

#### WSL Specific Notes

- **Audio Playback**: Uses `wslpath` to convert paths, then calls PowerShell.exe
- **Windows Integration**: Audio plays through Windows audio system
- **Performance**: Excellent - native Linux tools with Windows audio

---

### Cygwin

Cygwin is another Windows compatibility layer (less common than Git Bash/WSL).

#### Prerequisites

1. Install Cygwin from https://www.cygwin.com/
2. Ensure `bash`, `git`, and `cygpath` are installed

#### Installation Steps

Same as Git Bash, but the installer will automatically detect Cygwin and use `cygpath` for path conversion.

---

## macOS

macOS has native Bash and excellent audio support.

### Prerequisites

1. **Install Claude Code**:
   ```bash
   # Follow: https://docs.claude.com/claude-code
   ```

2. **Git** (usually pre-installed):
   ```bash
   git --version
   # If not installed, it will prompt you to install Xcode Command Line Tools
   ```

### Installation Steps

1. **Clone the repository**:
   ```bash
   cd ~
   git clone https://github.com/ChanMeng666/claude-code-audio-hooks.git
   cd claude-code-audio-hooks
   ```

2. **Run the installer**:
   ```bash
   bash scripts/install.sh
   ```

3. **Verify and test**:
   ```bash
   bash scripts/verify-path-detection.sh
   bash scripts/test-audio.sh
   ```

4. **Restart Claude Code** and test!

### macOS Specific Notes

- **Audio Playback**: Uses `afplay` (built into macOS)
- **No Additional Dependencies**: Works out of the box
- **Project Location**: Can be installed anywhere

### Common macOS Issues

**Issue: "command not found: claude"**
```bash
# Make sure Claude Code is in your PATH
# Add to ~/.zshrc or ~/.bash_profile:
export PATH="$PATH:/path/to/claude"
```

**Issue: "Operation not permitted"**
```bash
# Give Terminal full disk access:
# System Preferences > Security & Privacy > Privacy > Full Disk Access
# Add Terminal.app
```

---

## Linux

Linux has the best support with multiple audio player options.

### Prerequisites

1. **Install Claude Code**:
   ```bash
   # Follow: https://docs.claude.com/claude-code
   ```

2. **Install audio player** (choose one):
   ```bash
   # Ubuntu/Debian:
   sudo apt-get install mpg123
   # OR
   sudo apt-get install alsa-utils
   # OR
   sudo apt-get install pulseaudio-utils

   # Fedora/RHEL:
   sudo dnf install mpg123

   # Arch:
   sudo pacman -S mpg123
   ```

3. **Git** (usually pre-installed):
   ```bash
   sudo apt-get install git  # Ubuntu/Debian
   sudo dnf install git       # Fedora/RHEL
   sudo pacman -S git         # Arch
   ```

### Installation Steps

1. **Clone the repository**:
   ```bash
   cd ~
   git clone https://github.com/ChanMeng666/claude-code-audio-hooks.git
   cd claude-code-audio-hooks
   ```

2. **Run the installer**:
   ```bash
   bash scripts/install.sh
   ```

3. **Verify and test**:
   ```bash
   bash scripts/verify-path-detection.sh
   bash scripts/test-audio.sh
   ```

4. **Restart Claude Code** and test!

### Linux Specific Notes

- **Audio Players**: Tries mpg123, aplay, ffplay, paplay in order
- **Best Player**: `mpg123` is recommended for MP3 files
- **Headless Servers**: Audio won't work on servers without audio hardware/drivers

### Common Linux Issues

**Issue: "No audio device found"**
```bash
# Check if audio is working
aplay -l  # List audio devices

# Install ALSA if needed
sudo apt-get install alsa-utils

# Test system audio
speaker-test -t wav -c 2
```

**Issue: "mpg123: command not found"**
```bash
sudo apt-get install mpg123
```

---

## Common Issues and Solutions

### 1. "Project directory not found"

**Symptoms:**
- Hooks can't find audio files
- Error messages about missing paths

**Solution:**
```bash
# Re-run the installer to record the project path
cd /path/to/claude-code-audio-hooks
bash scripts/install.sh

# Verify path detection
bash scripts/verify-path-detection.sh
```

### 2. "No audio playing"

**Symptoms:**
- Hooks execute but no sound
- Silent operation

**Diagnosis:**
```bash
# Test audio directly
cd /path/to/claude-code-audio-hooks
bash scripts/test-audio.sh

# Check system volume
# - Windows: Volume mixer
# - macOS: System Preferences > Sound
# - Linux: alsamixer or pavucontrol
```

**Solutions:**
- **Windows (Git Bash)**: Ensure PowerShell.exe is in PATH
- **Windows (WSL)**: Ensure Windows audio is working
- **macOS**: Check volume and audio output device
- **Linux**: Install `mpg123` or other audio player

### 3. "Permission denied"

**Symptoms:**
- Can't execute scripts
- Hook files not executable

**Solution:**
```bash
# Make scripts executable
cd /path/to/claude-code-audio-hooks
chmod +x scripts/*.sh
chmod +x ~/.claude/hooks/*.sh

# Re-run installer
bash scripts/install.sh
```

### 4. "Path contains spaces"

**Symptoms:**
- Installation fails
- Audio files not found

**Solution:**
```bash
# Avoid spaces in project path
# BAD:  ~/My Documents/claude-code-audio-hooks
# GOOD: ~/Documents/claude-code-audio-hooks
# GOOD: ~/projects/claude-code-audio-hooks

# If you must use spaces, ensure proper quoting in scripts
```

### 5. "Python not found"

**Symptoms:**
- Configuration not loaded
- All hooks disabled

**Solution:**
```bash
# Install Python 3
# Ubuntu/Debian:
sudo apt-get install python3

# macOS:
brew install python3

# Windows (Git Bash):
# Download from python.org
# Or use: winget install Python.Python.3
```

**Note:** The system works without Python, but with limited configuration (only 3 default hooks enabled: notification, stop, subagent_stop)

---

## Platform-Specific Notes

### Project Location Flexibility

The project can be installed **anywhere** on your system:

**✅ Supported locations:**
- `~/claude-code-audio-hooks` (recommended)
- `~/projects/claude-code-audio-hooks`
- `~/Documents/claude-code-audio-hooks`
- `D:/github_repository/claude-code-audio-hooks` (Windows)
- `/opt/claude-code-audio-hooks` (Linux)
- Any custom location

The installer automatically records your project location in `~/.claude/hooks/.project_path`.

### Path Detection Strategy

The hooks use a 3-tier strategy to find the project:

1. **Read `.project_path` file** (created during installation) ✅ Most reliable
2. **Check project structure** (if hooks are inside project)
3. **Search common locations** (fallback)

### Audio Playback Matrix

| Platform | Environment | Audio Player | Status |
|----------|-------------|--------------|--------|
| Windows | Git Bash | PowerShell.exe | ✅ Full Support |
| Windows | WSL | PowerShell.exe + wslpath | ✅ Full Support |
| Windows | PowerShell | Native PowerShell | ⚠️ Limited (use Git Bash) |
| Windows | Cygwin | PowerShell.exe + cygpath | ✅ Full Support |
| macOS | Terminal | afplay | ✅ Full Support |
| macOS | iTerm2 | afplay | ✅ Full Support |
| Linux | Any terminal | mpg123/aplay/paplay | ✅ Full Support |
| Linux | Headless server | N/A | ❌ No audio hardware |

### Configuration Files

All configuration is stored in:
- **Hooks**: `~/.claude/hooks/*.sh`
- **Settings**: `~/.claude/settings.json`
- **Permissions**: `~/.claude/settings.local.json`
- **Preferences**: `<project-dir>/config/user_preferences.json`
- **Audio files**: `<project-dir>/audio/default/*.mp3`

---

## Getting Help

If you encounter issues not covered here:

1. **Run diagnostics**:
   ```bash
   bash scripts/verify-path-detection.sh
   bash scripts/check-setup.sh
   ```

2. **Check logs** (if hooks are failing):
   ```bash
   # Check recent hook triggers
   cat /tmp/claude_hooks_log/hook_triggers.log
   ```

3. **Test audio manually**:
   ```bash
   bash scripts/test-audio.sh
   ```

4. **Open an issue**: https://github.com/ChanMeng666/claude-code-audio-hooks/issues
   - Include your OS/environment (Windows Git Bash, WSL, macOS, Linux)
   - Include output from `bash scripts/verify-path-detection.sh`
   - Include output from `bash scripts/test-audio.sh`

---

## Summary

- **Windows users**: Use Git Bash (recommended) or WSL for best experience
- **macOS/Linux users**: Works out of the box with minimal dependencies
- **Project location**: Can be installed anywhere - installer records the path
- **Audio playback**: Platform-specific methods ensure compatibility
- **Configuration**: Centralized in `~/.claude/` directory

Happy coding with audio notifications! 🔊
