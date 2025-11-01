# Changelog

All notable changes to Claude Code Audio Hooks will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2025-01-XX

### 🎉 Major Release: Multi-Hook Support

This is a **major update** that transforms the project from a single notification system to a comprehensive multi-event audio notification platform.

### Added

**New Hook Types (8 total, up from 1):**
- ⚠️ **Notification Hook** - Alerts for authorization/confirmation requests (NEW!)
- ✅ **Stop Hook** - Task completion (existing, enhanced)
- 🔨 **PreToolUse Hook** - Before tool execution (NEW!)
- 📊 **PostToolUse Hook** - After tool execution (NEW!)
- 💬 **UserPromptSubmit Hook** - Prompt submission confirmation (NEW!)
- 🤖 **SubagentStop Hook** - Background task completion (NEW!)
- 🗜️ **PreCompact Hook** - Before conversation compaction (NEW!)
- 👋 **SessionStart/End Hooks** - Session boundaries (NEW!)

**Core Features:**
- **Configuration System**: JSON-based user preferences for enabling/disabling hooks
- **Interactive Configuration Tool**: `scripts/configure.sh` for easy setup
- **Audio Queue System**: Prevents overlapping sounds with intelligent queuing
- **Debounce System**: Prevents notification spam with configurable delays
- **Modular Architecture**: Shared configuration library for all hooks
- **Cross-Platform Support**: Enhanced WSL, Linux, and macOS compatibility

**New Scripts:**
- `scripts/configure.sh` - Interactive configuration tool
- `scripts/upgrade.sh` - Automatic migration from v1.0
- Enhanced `scripts/install.sh` - Multi-hook installation with auto-upgrade
- Enhanced `scripts/uninstall.sh` - Complete system removal
- Enhanced `scripts/check-setup.sh` - Comprehensive verification (12 checks)
- Enhanced `scripts/test-audio.sh` - Test all audio files with diagnostics

**New Documentation:**
- `docs/AUDIO_CREATION.md` - Comprehensive audio file creation guide
- `docs/CONFIGURATION.md` - Configuration reference (planned)
- `docs/HOOKS_GUIDE.md` - Detailed hook explanations (planned)
- `audio/README.md` - Audio file usage guide
- Updated main `README.md` with v2.0 features

**New Directory Structure:**
- `audio/default/` - Default audio files (9 files)
- `audio/custom/` - User custom audio directory
- `audio/legacy/` - Preserved v1.0 audio
- `hooks/shared/` - Shared configuration library
- `config/` - User configuration files
- `scripts/` - All utility scripts
- `docs/` - Comprehensive documentation
- `examples/` - Example configuration files

### Changed

**Breaking Changes:**
- Project structure completely reorganized
- Single `play_audio.sh` replaced with 9 specialized hook scripts
- Audio file location moved from `audio/` to `audio/default/`
- Configuration now required for customization

**Improvements:**
- **580-line shared library** (`hook_config.sh`) with robust error handling
- **Automatic upgrade** from v1.0 with user data preservation
- **Better audio management** with queue and debounce systems
- **Enhanced error messages** and troubleshooting guides
- **Backup system** for all configuration changes

### Deprecated

- Legacy `play_audio.sh` (v1.0) - Replaced by modular hook scripts
- Direct audio file in project root - Moved to `audio/default/`

### Removed

- Nothing removed - full backward compatibility maintained through upgrade path

### Fixed

- Audio overlap issues with queue system
- Notification spam with debounce system
- Path resolution issues with improved detection
- Permission handling for all hook scripts

### Security

- All hook scripts require explicit permission in `settings.local.json`
- Automatic backup before configuration changes
- Safe upgrade path with data preservation

## [1.0.0] - 2024-XX-XX

### Initial Release

- Basic audio notification on Stop hook
- Single `play_audio.sh` script
- WSL PowerShell audio playback
- Simple installation script
- Basic documentation

---

## Upgrade Guide

### From v1.0 to v2.0

**Option 1: Automatic Upgrade (Recommended)**
```bash
cd ~/claude-code-audio-hooks
git pull
bash scripts/install.sh  # Automatically detects and upgrades v1.0
```

**Option 2: Manual Upgrade**
```bash
cd ~/claude-code-audio-hooks
git pull
bash scripts/upgrade.sh
```

**What's Preserved:**
- Your custom audio file (moved to `audio/legacy/` and copied to `task-complete.mp3`)
- Your Claude Code settings (backed up before changes)
- Your permissions configuration

**What Changes:**
- Multiple hook scripts installed instead of single `play_audio.sh`
- Audio files moved to `audio/default/` directory
- Configuration file created at `config/user_preferences.json`
- New hooks added (enabled by default: Notification, Stop, SubagentStop)

**Post-Upgrade:**
1. Restart Claude Code
2. Run `bash scripts/check-setup.sh` to verify
3. Run `bash scripts/test-audio.sh` to test
4. Run `bash scripts/configure.sh` to customize

---

## Roadmap

### v2.1.0 (Planned)
- Volume control per hook type
- Time-based quiet hours
- Web UI for configuration
- More audio file presets

### v2.2.0 (Planned)
- Matcher pattern support for conditional triggers
- Context-aware audio selection
- Integration with system notifications
- Mobile app companion

### v3.0.0 (Future)
- Webhook support for external services
- Analytics dashboard
- Community audio marketplace
- Plugin system for extensions

---

## Contributors

- **Chan Meng** - Initial work and v2.0 development
- **Community** - Bug reports, feature requests, and testing

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- Anthropic for Claude Code and the extensible hooks system
- ElevenLabs for AI-powered text-to-speech services
- The open source community for inspiration and support

---

**Note:** For detailed information about each version, see the corresponding release notes on GitHub.
