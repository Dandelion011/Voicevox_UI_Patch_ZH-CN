# VOICEVOX 0.26.1 简体中文补丁

适用：Windows 版 VOICEVOX 0.26.1。

## 安装

下载并解压 `VOICEVOX-0.26.1-zh-CN-patch.zip`，完全退出 VOICEVOX，在解压目录打开 PowerShell 并运行：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install_patch.ps1 "E:\Voicevox"
```

如果安装目录不同，请替换命令中的 `E:\Voicevox`。安装器会校验目标版本、备份原始 `app.asar`，并在写入后校验补丁哈希。未知版本会被拒绝，不会强制覆盖。

## 卸载

完全退出 VOICEVOX 后运行：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\uninstall_patch.ps1 "E:\Voicevox"
```

## 主要内容

- 覆盖主界面、设置、快捷键、自定义工具栏、歌曲编辑器、词典、引擎管理和常见对话框。
- 角色一级名称保持原文，二级风格名称翻译。
- 不修改引擎请求、音色/风格 ID、快捷键内部动作或用户项目文件。
- 独立 ASAR 文件 SHA-256：`FDCE15AA2886D7CFA569800F73ECE5F73832DDA443375C070BDFC6FA02FDC5AE`。

详细说明见压缩包内的 `README.md`。
