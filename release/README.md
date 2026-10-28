# VOICEVOX 0.26.1 简体中文界面补丁

这是针对 Windows 版 `VOICEVOX 0.26.1` 的非官方简体中文界面补丁。

补丁覆盖主界面、设置页、快捷键设置、自定义工具栏、歌曲编辑器、词典、引擎管理、确认对话框、右键菜单和工具提示等界面文字。角色一级名称保持原文，角色二级风格名称会翻译。补丁不修改引擎请求、音色 ID、风格 ID、快捷键内部标识或用户项目文件。

## 下载和安装

1. 在本仓库的 Releases 页面下载最新的 `VOICEVOX-0.26.1-zh-CN-patch.zip`。
2. 将 ZIP 解压到任意目录，例如 `F:\VoicevoxChi`。
3. 完全退出 VOICEVOX，包括系统托盘中的进程。
4. 在解压后的补丁目录打开 PowerShell，执行：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install_patch.ps1 "E:\Voicevox"
```

如果你的 VOICEVOX 安装目录不是 `E:\Voicevox`，把命令最后的路径替换成实际安装目录。安装脚本会先验证原版或已知旧补丁的哈希，在 `resources` 目录备份原始 `app.asar`，再替换为汉化版本。替换后的文件还会再次核验，失败时会自动恢复备份。

安装完成后重新启动 VOICEVOX 即可。

## 恢复原版

完全退出 VOICEVOX 后，在补丁目录执行：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\uninstall_patch.ps1 "E:\Voicevox"
```

卸载脚本会恢复最近的原版备份。补丁不会删除原始备份。

## 适用版本和安全边界

- 仅适用于 `VOICEVOX 0.26.1` Windows 版。
- 升级或降级 VOICEVOX 后不要继续使用本补丁。
- 安装器遇到未知的 `app.asar` 哈希会拒绝覆盖，不会强行修改文件。
- 补丁只替换界面显示层，不修改引擎、模型、音频数据或项目文件。

补丁 `app.asar` SHA-256（用于核对 Release 中的独立 ASAR 文件）：

```text
FDCE15AA2886D7CFA569800F73ECE5F73832DDA443375C070BDFC6FA02FDC5AE
```

## 从源码重新构建

需要 Node.js 和 `@electron/asar`。原始 `app.asar` 解包目录应放在 `work/app`：

```powershell
node .\build_patch.mjs .\work\app .\build\app-next
npm exec --yes --package @electron/asar -- asar pack .\build\app-next .\build\VOICEVOX-0.26.1-zh-CN.asar
```

构建脚本只处理明确的界面显示文字，并保留原始应用逻辑。
