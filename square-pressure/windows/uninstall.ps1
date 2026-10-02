<#
.SYNOPSIS
  Removes Square Pressure: shortcuts, the Settings > Apps entry and the program
  folder. Run by Windows from Settings > Apps > Installed apps.
  Session stats live in the browser's local storage and are not touched.
#>
param([switch]$Quiet)

$ErrorActionPreference = 'SilentlyContinue'
$AppName = 'Square Pressure'
$AppId   = 'SquarePressure'
$Dest    = Join-Path $env:LOCALAPPDATA "Programs\$AppName"

foreach ($folder in [Environment]::GetFolderPath('Programs'), [Environment]::GetFolderPath('Desktop')) {
  Remove-Item -LiteralPath (Join-Path $folder "$AppName.lnk") -Force
}
Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\$AppId" -Recurse -Force

# This script runs from inside $Dest, so the folder is removed once it exits.
if ($env:LOCALAPPDATA -and (Test-Path -LiteralPath $Dest)) {
  Start-Process -FilePath cmd.exe -WindowStyle Hidden `
    -ArgumentList "/c timeout /t 2 /nobreak >nul & rmdir /s /q `"$Dest`""
}

if (-not $Quiet) {
  Add-Type -AssemblyName PresentationFramework
  [System.Windows.MessageBox]::Show("$AppName has been removed.", $AppName) | Out-Null
}
