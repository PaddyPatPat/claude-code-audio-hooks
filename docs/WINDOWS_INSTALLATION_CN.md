# Windows 安装指南 (中文)

本指南专门针对Windows用户，提供详细的安装说明和常见问题解决方案。

## 目录

- [支持的Windows环境](#支持的windows环境)
- [推荐安装方式](#推荐安装方式)
- [详细安装步骤](#详细安装步骤)
- [常见问题](#常见问题)
- [故障排除](#故障排除)

---

## 支持的Windows环境

本项目支持以下Windows环境：

| 环境 | 推荐度 | 说明 |
|------|--------|------|
| **Git Bash** | ⭐⭐⭐⭐⭐ **强烈推荐** | 最佳兼容性，安装简单 |
| **WSL 2** | ⭐⭐⭐⭐ 推荐 | Linux环境，功能完整 |
| **Cygwin** | ⭐⭐⭐ 可用 | 兼容但不常用 |
| **PowerShell** | ⭐⭐ 有限支持 | 建议使用Git Bash代替 |

### 为什么推荐 Git Bash？

✅ **优点:**
- 无需安装WSL，更轻量
- 与Windows完美集成
- 自带Unix工具（bash, sed, grep等）
- 音频播放通过PowerShell.exe实现，完全兼容

❌ **PowerShell 的局限:**
- 安装脚本是用Bash编写的
- 缺少Unix工具
- 路径处理复杂

---

## 推荐安装方式

### 方案一：Git Bash（推荐）

#### 1. 安装 Git for Windows

从官网下载并安装：
- 官网: https://git-scm.com/download/win
- 或使用 winget: `winget install Git.Git`

安装时会自动安装 Git Bash。

#### 2. 安装 Claude Code

如果还没有安装：
- 访问：https://docs.claude.com/claude-code
- 下载并安装 Claude Code CLI

#### 3. 运行 Git Bash

从开始菜单找到 "Git Bash" 并打开。

#### 4. 克隆项目

```bash
# 可以克隆到任意位置，例如：
cd D:/github_repository  # 你的项目目录
git clone https://github.com/ChanMeng666/claude-code-audio-hooks.git
cd claude-code-audio-hooks

# 或者克隆到用户目录：
cd ~
git clone https://github.com/ChanMeng666/claude-code-audio-hooks.git
cd claude-code-audio-hooks
```

**重要提示：** 项目可以安装在任意位置！安装脚本会自动记录项目路径。

#### 5. 运行安装脚本

```bash
bash scripts/install.sh
```

安装过程会：
- ✅ 检查所有前置条件
- ✅ 复制hooks脚本到 `~/.claude/hooks/`
- ✅ 记录项目路径到 `.project_path` 文件
- ✅ 配置 `settings.json` 和 `settings.local.json`
- ✅ 设置音频播放（通过PowerShell.exe）

#### 6. 验证安装

```bash
# 运行平台诊断工具
bash scripts/diagnose-platform.sh

# 验证路径检测
bash scripts/verify-path-detection.sh

# 测试音频播放
bash scripts/test-audio.sh
# 选择选项 4 进行快速测试
```

#### 7. 重启 Claude Code

**非常重要：** 必须重启Claude Code才能使hooks生效！

1. 关闭所有Claude Code窗口
2. 在Git Bash中重新打开Claude Code
3. 测试: `claude "2+2等于多少?"`
4. 完成后应该听到音频通知！

---

### 方案二：WSL 2（高级用户）

#### 1. 安装 WSL 2

在PowerShell（管理员权限）中运行：
```powershell
wsl --install
```

#### 2. 安装 Ubuntu

```powershell
wsl --install -d Ubuntu
```

#### 3. 在 WSL 中安装 Claude Code

打开WSL终端，按照Linux安装说明进行。

#### 4. 安装本项目

```bash
cd ~
git clone https://github.com/ChanMeng666/claude-code-audio-hooks.git
cd claude-code-audio-hooks
bash scripts/install.sh
```

**WSL特点：**
- ✅ 完整的Linux环境
- ✅ 音频通过Windows音频系统播放
- ✅ 自动使用 `wslpath` 进行路径转换

---

## 详细安装步骤

### 安装过程详解

当你运行 `bash scripts/install.sh` 时，脚本会执行以下操作：

#### 1. 前置条件检查

```
✓ Claude Code directory found
✓ Python 3 is available (或警告：未安装，将使用默认配置)
✓ Project directory structure validated
```

#### 2. 安装 Hook 脚本

```
✓ Hooks directory ready: ~/.claude/hooks
Recording project path...
✓ Project path recorded: D:/github_repository/claude-code-audio-hooks
✓ Shared library installed
Installing hook scripts...
✓ Installed 9 hook scripts
```

**关键文件：**
- `~/.claude/hooks/.project_path` - 记录项目路径（无论项目在哪里）
- `~/.claude/hooks/shared/hook_config.sh` - 共享配置库
- `~/.claude/hooks/*_hook.sh` - 9个hook脚本

#### 3. 配置 settings.json

在 `~/.claude/settings.json` 中添加：

```json
{
  "hooks": {
    "Notification": [...],
    "Stop": [...],
    "PreToolUse": [...],
    "PostToolUse": [...],
    "UserPromptSubmit": [...],
    "SubagentStop": [...],
    "PreCompact": [...],
    "SessionStart": [...],
    "SessionEnd": [...]
  }
}
```

#### 4. 配置权限

在 `~/.claude/settings.local.json` 中添加：

```json
{
  "toolPermissions": {
    "allow": [
      "Bash(~/.claude/hooks/notification_hook.sh:*)",
      "Bash(~/.claude/hooks/stop_hook.sh:*)",
      ...
    ]
  }
}
```

#### 5. 创建配置文件

如果不存在，创建 `config/user_preferences.json`：

```json
{
  "enabled_hooks": {
    "notification": true,  // ✅ 权限请求提醒
    "stop": true,          // ✅ 任务完成提醒
    "subagent_stop": true, // ✅ 后台任务完成
    "pretooluse": false,   // ❌ 太吵
    "posttooluse": false,  // ❌ 太吵
    ...
  }
}
```

---

## 常见问题

### Q1: 项目必须安装在 `~/claude-code-audio-hooks` 吗？

**答：不需要！** 项目可以安装在任意位置。

✅ **支持的位置：**
- `~/claude-code-audio-hooks`
- `~/projects/claude-code-audio-hooks`
- `D:/github_repository/claude-code-audio-hooks`
- `/opt/claude-code-audio-hooks`
- 任何自定义位置

安装脚本会自动将项目路径记录在 `~/.claude/hooks/.project_path` 文件中。

### Q2: 为什么显示"系统找不到指定的路径"（乱码）？

**原因：** Windows中文系统编码问题。

**解决方案：**
1. 使用Git Bash（不是PowerShell）
2. 重新运行安装: `bash scripts/install.sh`
3. 检查路径检测: `bash scripts/verify-path-detection.sh`

### Q3: 听不到音频怎么办？

**诊断步骤：**

1. **运行诊断工具**：
   ```bash
   bash scripts/diagnose-platform.sh
   ```

2. **测试音频播放**：
   ```bash
   bash scripts/test-audio.sh
   ```

3. **检查PowerShell是否可用**（Git Bash环境）：
   ```bash
   powershell.exe -Command "Write-Host 'PowerShell works'"
   ```

4. **检查系统音量**：
   - 确保Windows音量未静音
   - 尝试播放其他音频确认音频系统工作

5. **手动测试音频**：
   ```bash
   # 手动播放一个音频文件
   powershell.exe -Command "Add-Type -AssemblyName presentationCore; \$player = New-Object System.Windows.Media.MediaPlayer; \$player.Open('C:/Users/YourName/claude-code-audio-hooks/audio/default/task-complete.mp3'); \$player.Play(); Start-Sleep -Seconds 3"
   ```

### Q4: Python 未安装会影响使用吗？

**答：不会！** 但功能会受限。

**有 Python 3：**
- ✅ 可以在 `config/user_preferences.json` 中配置所有hooks
- ✅ 可以自定义音频文件
- ✅ 可以调整防抖动和队列设置

**无 Python 3：**
- ✅ 系统仍然工作
- ✅ 自动启用3个默认hooks（notification, stop, subagent_stop）
- ❌ 无法读取自定义配置

**安装 Python 3（可选）：**
- 从 https://www.python.org/ 下载
- 或使用 winget: `winget install Python.Python.3`

### Q5: 如何更改项目位置？

如果移动了项目目录：

```bash
# 1. 进入新的项目目录
cd /new/path/to/claude-code-audio-hooks

# 2. 重新运行安装（会更新路径记录）
bash scripts/install.sh

# 3. 验证新路径
bash scripts/verify-path-detection.sh
```

### Q6: Git Bash 和 WSL 有什么区别？

| 特性 | Git Bash | WSL |
|------|----------|-----|
| 安装难度 | ⭐ 简单 | ⭐⭐ 中等 |
| 性能 | 快速 | 快速 |
| Unix工具 | 基本工具 | 完整Linux |
| 路径转换 | 自动（sed） | 自动（wslpath） |
| 音频播放 | PowerShell.exe | PowerShell.exe |
| 推荐场景 | 日常使用 | 需要完整Linux环境 |

---

## 故障排除

### 错误：hooks找不到音频文件

**症状：**
```
PreToolUse:Bash hook error: Failed with non-blocking status code: 系统找不到指定的路径
```

**原因：** 项目路径检测失败或 `.project_path` 文件不存在。

**解决方案：**

1. **检查 `.project_path` 文件**：
   ```bash
   cat ~/.claude/hooks/.project_path
   ```

   应该显示项目的完整路径，例如：
   ```
   D:/github_repository/claude-code-audio-hooks
   ```

2. **如果文件不存在或路径错误，重新运行安装**：
   ```bash
   cd /path/to/claude-code-audio-hooks
   bash scripts/install.sh
   ```

3. **验证路径检测**：
   ```bash
   bash scripts/verify-path-detection.sh
   ```

### 错误：权限被拒绝

**症状：**
```
bash: scripts/install.sh: Permission denied
```

**解决方案：**
```bash
chmod +x scripts/*.sh
bash scripts/install.sh
```

### 错误：PowerShell.exe 未找到

**症状：**
音频不播放，或显示 "powershell.exe: command not found"

**解决方案：**

1. **检查PowerShell路径**：
   ```bash
   which powershell.exe
   ```

2. **如果未找到，添加到PATH**：
   在 `~/.bashrc` 中添加：
   ```bash
   export PATH="$PATH:/c/Windows/System32/WindowsPowerShell/v1.0"
   ```

3. **重新加载配置**：
   ```bash
   source ~/.bashrc
   ```

### 错误：音频播放后立即停止

**原因：** PowerShell脚本问题或音频文件损坏。

**解决方案：**

1. **检查音频文件**：
   ```bash
   ls -lh audio/default/
   ```

   所有文件应该有合理的大小（15-30KB）。

2. **手动测试音频文件**：
   在Windows文件浏览器中双击音频文件，看是否能播放。

3. **重新克隆项目**（如果音频文件损坏）：
   ```bash
   cd ~
   rm -rf claude-code-audio-hooks
   git clone https://github.com/ChanMeng666/claude-code-audio-hooks.git
   cd claude-code-audio-hooks
   bash scripts/install.sh
   ```

---

## 高级配置

### 自定义音频文件

1. **准备MP3文件**（建议2-3秒长）

2. **复制到项目**：
   ```bash
   cp /path/to/your-audio.mp3 audio/custom/my-notification.mp3
   ```

3. **编辑配置**（需要Python 3）：
   编辑 `config/user_preferences.json`：
   ```json
   {
     "audio_files": {
       "notification": "custom/my-notification.mp3"
     }
   }
   ```

4. **测试**：
   ```bash
   bash scripts/test-audio.sh
   ```

### 启用/禁用特定hooks

使用交互式配置工具：

```bash
bash scripts/configure.sh
```

或手动编辑 `config/user_preferences.json`：

```json
{
  "enabled_hooks": {
    "notification": true,    // 权限请求 - 推荐启用
    "stop": true,            // 任务完成 - 推荐启用
    "pretooluse": true,      // 工具执行前 - 可能太吵
    "posttooluse": false,    // 工具执行后 - 通常太吵
    "userpromptsubmit": false, // 提交提示 - 不需要
    "subagent_stop": true,   // 后台任务 - 推荐启用
    "precompact": false,     // 压缩前 - 不需要
    "session_start": false,  // 会话开始 - 不需要
    "session_end": false     // 会话结束 - 不需要
  }
}
```

---

## 卸载

如需卸载：

```bash
cd /path/to/claude-code-audio-hooks
bash scripts/uninstall.sh
```

卸载会：
- ✅ 备份hooks到 `~/.claude/hooks_backup_<timestamp>/`
- ✅ 删除所有hook脚本
- ✅ 从 `settings.json` 移除hook配置（创建备份）
- ✅ 保留项目目录（包含音频文件）

完全删除：

```bash
bash scripts/uninstall.sh
cd ~
rm -rf claude-code-audio-hooks
```

---

## 获取帮助

### 诊断工具

遇到问题时，首先运行：

```bash
# 1. 平台诊断（自动检测环境和问题）
bash scripts/diagnose-platform.sh

# 2. 路径验证
bash scripts/verify-path-detection.sh

# 3. 音频测试
bash scripts/test-audio.sh

# 4. 完整检查
bash scripts/check-setup.sh
```

### 文档资源

- **跨平台安装指南**：`docs/CROSS_PLATFORM_INSTALLATION.md`
- **主README**：`README.md`
- **AI安装指南**：`AI_SETUP_GUIDE.md`
- **音频创建指南**：`docs/AUDIO_CREATION.md`

### 报告问题

如果问题仍未解决，请在GitHub上创建issue：

https://github.com/ChanMeng666/claude-code-audio-hooks/issues

**请包含以下信息：**
1. 操作系统和环境（Git Bash版本、Windows版本）
2. `bash scripts/diagnose-platform.sh` 的输出
3. `bash scripts/verify-path-detection.sh` 的输出
4. 遇到的具体错误信息

---

## 总结

✅ **推荐配置：**
- **环境**：Git Bash（安装Git for Windows即可）
- **位置**：任意目录（会自动记录路径）
- **Hooks**：默认3个（notification, stop, subagent_stop）
- **测试**：使用 `bash scripts/test-audio.sh`

✅ **关键文件：**
- `~/.claude/hooks/.project_path` - 项目路径记录
- `~/.claude/hooks/shared/hook_config.sh` - 核心配置库
- `~/.claude/settings.json` - Hook配置
- `config/user_preferences.json` - 用户偏好

🎉 **安装完成后，享受音频通知带来的便利！**

如有问题，请随时查看文档或在GitHub创建issue。

Happy coding! 🔊
