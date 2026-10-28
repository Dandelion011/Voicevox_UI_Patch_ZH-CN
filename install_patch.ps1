$ErrorActionPreference = 'Stop'
$patchRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$installRoot = if ($args.Count -gt 0) { [IO.Path]::GetFullPath($args[0]) } else { 'E:\Voicevox' }
$asar = Join-Path $installRoot 'resources\app.asar'
$patched = Join-Path $patchRoot 'build\VOICEVOX-0.26.1-zh-CN.asar'
$originalHash = '8CE37DB2040C15E1AD071D7B80D4884854A4D05E307543BABE924A3FFB3C954F'
$patchedHash = 'FDCE15AA2886D7CFA569800F73ECE5F73832DDA443375C070BDFC6FA02FDC5AE'
$previousPatchedHashes = @(
  'E9323DEDB6D5BC7539878FD23F63474E893F52221144C9A0808917300F5184B7',
  '8908CAFD1FFD454E208E2F85B9C23E2AB4BA15FE6525FEAB8C17E8B455A34BBB',
  '16C74AA7F8C7126DE47EB8E38EB5C847AD97236509F442625B01A4547ECC3FCB',
  '33C76CD7A19FD46CB3D7E4A7973B4C66339424B1631968E356A8144682DB9E06',
  '6AC7300456C35572E6B7D3B9A87F7732F6A825D5C76669FD5C7BA2E98B55E7E4',
  'EE8AFD0AAE7F22377494D559DB428D2BD42FBF804AC94BF9D8661399FF0613D9',
  '2D059B7AA7AF8C25BBB184C1290A1316C1D6519623651B284A29C2CE3906E44E',
  '7B5A4F7B1ABDE71CFE7134AF3592A4A5B4E29EE83F710FC1902000B0D7728FCE',
  '0A3ABD54B26E2F1D7F881A8B41C7232FFC507F2F66CEF16EBBFC4AF128EB88B3',
  '142D8F43A0F2146FD9123BA0C2DD85DAE06C10F27F2801F33887948102FA8707',
  'F94FCCBCC12FD587856A91CB0A43B99A478F4E2B81876D4E2ED9A432B74A961B',
  '5BD1B92340BFC0699A0B3C8D6D58E9ACA540CFA70A61F67B793841ABB1927008',
  '98C92A7FBBBA8744D3D8BF6647EB3673470338FF349A5924E3650E09AEA466B6',
  'B5623572E06E71F157B0AE26FC7AB63D2000590D9277A038439087161AD494D8',
  '81C5961963ECF3AF81A63CC2F9F8E3782AFCE3736324F149EE807BB3F36347ED',
  'A962FD18870D13C9BE0AA0AF1CF743D8F5782042342EC039EBC0BBDBC88EC446',
  '2434487AC55349FEF05B06DD26165D93DF3B321F25288F7A6740BDEF5AF7D70F',
  'B0541DABBCF53F61F8FE97AE65837D40FCF97C1BF13CE427AB500BCD21DEA105'
)

if (-not (Test-Path -LiteralPath $asar)) { throw "Original app.asar not found: $asar" }
if (-not (Test-Path -LiteralPath $patched)) { throw "Patch file not found: $patched" }

$currentHash = (Get-FileHash -LiteralPath $asar -Algorithm SHA256).Hash.ToUpperInvariant()
$buildHash = (Get-FileHash -LiteralPath $patched -Algorithm SHA256).Hash.ToUpperInvariant()
if ($buildHash -ne $patchedHash) {
  throw "Patch file hash does not match the expected build. SHA-256: $buildHash"
}
if ($currentHash -eq $patchedHash) {
  Write-Host 'This patch is already installed.'
  exit 0
}
if ($previousPatchedHashes -contains $currentHash) {
  $restore = Get-ChildItem -LiteralPath (Join-Path $installRoot 'resources') -Filter 'app.asar.original.*' -File |
    Where-Object { (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash.ToUpperInvariant() -eq $originalHash } |
    Sort-Object LastWriteTime -Descending | Select-Object -First 1 -ExpandProperty FullName
  if (-not $restore) { throw 'An older patch is installed, but its original app.asar backup was not found.' }
  Copy-Item -LiteralPath $restore -Destination $asar -Force
  $currentHash = (Get-FileHash -LiteralPath $asar -Algorithm SHA256).Hash.ToUpperInvariant()
}
if ($currentHash -ne $originalHash) {
  throw "Target app.asar is not the original VOICEVOX 0.26.1 file. Refusing to overwrite it. SHA-256: $currentHash"
}

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backup = Join-Path $installRoot "resources\app.asar.original.$stamp"
Copy-Item -LiteralPath $asar -Destination $backup
Copy-Item -LiteralPath $patched -Destination $asar -Force
if ((Get-FileHash -LiteralPath $asar -Algorithm SHA256).Hash.ToUpperInvariant() -ne $patchedHash) {
  Copy-Item -LiteralPath $backup -Destination $asar -Force
  throw 'Installed patch verification failed. The original app.asar was restored from backup.'
}
Write-Host "Chinese patch installed. Original file backed up to: $backup"
Write-Host "To restore, run uninstall_patch.ps1."
