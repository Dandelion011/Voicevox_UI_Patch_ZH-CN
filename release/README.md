# VOICEVOX 0.26.1 简体中文界面补丁

这是针对 Windows 版 `VOICEVOX 0.26.1` 的非官方简体中文界面补丁。

补丁覆盖主界面、设置页、快捷键设置、自定义工具栏、歌曲编辑器、词典、引擎管理、确认对话框、右键菜单和工具提示等界面文字。角色一级名称保持原文，角色二级风格名称会翻译。补丁不修改引擎请求、音色 ID、风格 ID、快捷键内部标识或用户项目文件。

## 下载文件

从 Releases 下载 `VOICEVOX-0.26.1-zh-CN-manual.zip`，解压后会得到：

- `VOICEVOX-0.26.1-zh-CN.asar`：汉化后的补丁文件
- `README.md`：本手册

本版本不需要运行任何安装脚本。

## 手动安装

以下步骤不会删除原版文件。请按顺序操作。

### 1. 完全退出 VOICEVOX

关闭窗口后，再打开任务管理器，确认没有 `VOICEVOX.exe` 或 `VOICEVOX` 进程。系统托盘中如果还有 VOICEVOX，也要退出。

### 2. 打开安装目录

在文件资源管理器中进入 VOICEVOX 安装目录，例如：

```text
E:\Voicevox
```

进入其中的 `resources` 文件夹。目标文件应为：

```text
E:\Voicevox\resources\app.asar
```

如果找不到这个文件，或你的版本不是 `VOICEVOX 0.26.1`，请停止操作，不要覆盖其他版本。

### 3. 确认并备份原版文件

如果这是首次安装，在 `resources` 文件夹中复制 `app.asar`，然后将副本改名为：

```text
app.asar.original.manual
```

不要把原版文件移动到补丁目录，也不要删除它。确认 `resources` 中同时存在：

```text
app.asar
app.asar.original.manual
```

如果你之前安装过旧版汉化补丁，当前的 `app.asar` 可能已经是补丁文件。此时不要把它当作原版备份，也不要直接覆盖现有备份。先在 `resources` 文件夹打开 PowerShell，查看已有原版备份的哈希：

```powershell
Get-ChildItem .\app.asar.original.* -File | Get-FileHash -Algorithm SHA256 | Format-Table Path,Hash
```

找到哈希为 `8CE37DB2040C15E1AD071D7B80D4884854A4D05E307543BABE924A3FFB3C954F` 的备份，将它复制一份并命名为 `app.asar`。如果没有任何备份符合该哈希，或无法确定哪个文件是原版，请停止操作，不要继续替换。

### 4. 核对原版哈希

在 `resources` 文件夹空白处按住 Shift 并右键，选择“在此处打开 PowerShell”，运行：

```powershell
Get-FileHash .\app.asar.original.manual -Algorithm SHA256
```

原版 `VOICEVOX 0.26.1` 应为：

```text
8CE37DB2040C15E1AD071D7B80D4884854A4D05E307543BABE924A3FFB3C954F
```

如果哈希不同，请停止操作。这样可以避免误覆盖其他版本或旧补丁。

### 5. 替换为汉化文件

将解压出的 `VOICEVOX-0.26.1-zh-CN.asar` 复制到 `resources` 文件夹，然后改名为：

```text
app.asar
```

Windows 提示“是否替换目标文件”时选择“替换”。如果提示没有权限，请先确认 VOICEVOX 已完全退出，再以管理员权限打开文件资源管理器或 PowerShell 后重试。

### 6. 核对补丁文件

在 `resources` 文件夹运行：

```powershell
Get-FileHash .\app.asar -Algorithm SHA256
```

汉化后的 `app.asar` 应为：

```text
FDCE15AA2886D7CFA569800F73ECE5F73832DDA443375C070BDFC6FA02FDC5AE
```

只有补丁哈希完全一致时才启动 VOICEVOX。若界面仍是日文，请完全退出后再次启动，不要重复覆盖其他文件。

## 手动恢复原版

1. 完全退出 VOICEVOX。
2. 打开 `E:\Voicevox\resources`，或你的实际安装目录中的 `resources` 文件夹。
3. 将当前 `app.asar` 改名为 `app.asar.zh-CN.backup`，不要直接删除。
4. 将 `app.asar.original.manual` 复制一份，并将副本改名为 `app.asar`。
5. 启动 VOICEVOX，确认原版恢复。

也可以直接删除当前 `app.asar`，再将 `app.asar.original.manual` 复制并改名为 `app.asar`。保留汉化文件副本更便于排查问题，因此更推荐前一种方式。

## 安全边界

- 仅适用于 `VOICEVOX 0.26.1` Windows 版。
- 升级或降级 VOICEVOX 后不要继续使用本补丁。
- 不要删除 `app.asar.original.manual`，直到确认不再需要恢复原版。
- 补丁只替换界面显示层，不修改引擎、模型、音频数据或项目文件。
- 如果任何哈希与本手册不一致，请停止操作，不要强行覆盖。

## 从源码重新构建

需要 Node.js 和 `@electron/asar`。原始 `app.asar` 解包目录应放在 `work/app`：

```powershell
node .\build_patch.mjs .\work\app .\build\app-next
npm exec --yes --package @electron/asar -- asar pack .\build\app-next .\build\VOICEVOX-0.26.1-zh-CN.asar
```

构建脚本只处理明确的界面显示文字，并保留原始应用逻辑。
