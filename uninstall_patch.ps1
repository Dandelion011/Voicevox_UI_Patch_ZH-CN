$ErrorActionPreference = 'Stop'
$installRoot = if ($args.Count -gt 0) { [IO.Path]::GetFullPath($args[0]) } else { 'E:\Voicevox' }
$resources = Join-Path $installRoot 'resources'
$asar = Join-Path $resources 'app.asar'
$originalHash = '8CE37DB2040C15E1AD071D7B80D4884854A4D05E307543BABE924A3FFB3C954F'
$backup = if ($args.Count -gt 1) { [IO.Path]::GetFullPath($args[1]) } else {
  Get-ChildItem -LiteralPath $resources -Filter 'app.asar.original.*' -File |
    Where-Object { (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash.ToUpperInvariant() -eq $originalHash } |
    Sort-Object LastWriteTime -Descending | Select-Object -First 1 -ExpandProperty FullName
}
if (-not $backup) { throw "No original app.asar backup found. Pass the full backup path as the second argument." }
if (-not (Test-Path -LiteralPath $backup)) { throw "Backup file not found: $backup" }
if ((Get-FileHash -LiteralPath $backup -Algorithm SHA256).Hash.ToUpperInvariant() -ne $originalHash) {
  throw 'The selected backup is not the original VOICEVOX 0.26.1 app.asar. No files were changed.'
}
Copy-Item -LiteralPath $backup -Destination $asar -Force
Write-Host "Original app.asar restored from: $backup"
