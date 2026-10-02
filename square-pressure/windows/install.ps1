<#
.SYNOPSIS
  Installs Square Pressure for the current user (no admin rights needed).

.DESCRIPTION
  Copies the drill to %LOCALAPPDATA%\Programs\Square Pressure, adds Start menu
  and desktop shortcuts that open it in its own app window (Edge, or Chrome if
  Edge is missing), and registers it under Settings > Apps > Installed apps so
  it can be uninstalled like any other program. Re-running it upgrades in place.

.PARAMETER NoDesktop
  Skip the desktop shortcut.

.PARAMETER NoLaunch
  Do not open the app when installation finishes.
#>
param([switch]$NoDesktop, [switch]$NoLaunch)

$ErrorActionPreference = 'Stop'
$AppName = 'Square Pressure'
$AppId   = 'SquarePressure'
$Version = '1.0.0'
$Source  = Split-Path -Parent $PSScriptRoot
$Dest    = Join-Path $env:LOCALAPPDATA "Programs\$AppName"
$RegKey  = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\$AppId"

function Find-Browser {
  $found = @()
  foreach ($exe in 'msedge.exe', 'chrome.exe') {
    foreach ($hive in 'HKCU:', 'HKLM:') {
      $item = Get-ItemProperty -Path "$hive\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\$exe" -ErrorAction SilentlyContinue
      if ($item -and $item.'(default)') { $found += $item.'(default)'.Trim('"') }
    }
  }
  $found += "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
            "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
            "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
            "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
  $found | Where-Object { $_ -and (Test-Path -LiteralPath $_) } | Select-Object -First 1
}

if (-not (Test-Path -LiteralPath (Join-Path $Source 'index.html'))) {
  throw "Cannot find index.html next to the windows folder ($Source). Run this from inside the square-pressure folder."
}
$Browser = Find-Browser
if (-not $Browser) { throw 'Microsoft Edge or Google Chrome is required to run Square Pressure.' }

Write-Host "Installing $AppName $Version to $Dest"

# --- files -------------------------------------------------------------------
New-Item -ItemType Directory -Path (Join-Path $Dest 'icons') -Force | Out-Null
foreach ($f in 'index.html', 'manifest.webmanifest', 'sw.js') {
  Copy-Item -LiteralPath (Join-Path $Source $f) -Destination $Dest -Force
}
Copy-Item -Path (Join-Path $Source 'icons\*') -Destination (Join-Path $Dest 'icons') -Force
Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'uninstall.ps1') -Destination $Dest -Force
if (Get-Command Unblock-File -ErrorAction SilentlyContinue) {
  Get-ChildItem -LiteralPath $Dest -Recurse -File | Unblock-File
}

$Icon = Join-Path $Dest 'icons\square-pressure.ico'
$Url  = ([System.Uri](Join-Path $Dest 'index.html')).AbsoluteUri
$LaunchArgs = "--app=`"$Url`""

# --- shortcuts ---------------------------------------------------------------
$Shell = New-Object -ComObject WScript.Shell
function New-AppShortcut([string]$Folder) {
  $lnk = $Shell.CreateShortcut((Join-Path $Folder "$AppName.lnk"))
  $lnk.TargetPath       = $Browser
  $lnk.Arguments        = $LaunchArgs
  $lnk.WorkingDirectory = $Dest
  $lnk.IconLocation     = "$Icon,0"
  $lnk.Description      = 'Chess board-vision drill: mark every square one side attacks.'
  $lnk.Save()
}
New-AppShortcut ([Environment]::GetFolderPath('Programs'))
if (-not $NoDesktop) { New-AppShortcut ([Environment]::GetFolderPath('Desktop')) }

# --- Settings > Apps registration ---------------------------------------------
$Size = [int]((Get-ChildItem -LiteralPath $Dest -Recurse -File | Measure-Object Length -Sum).Sum / 1KB)
$Uninstall = "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$Dest\uninstall.ps1`""
New-Item -Path $RegKey -Force | Out-Null
$strings = @{
  DisplayName          = $AppName
  DisplayVersion       = $Version
  Publisher            = 'chess-drills'
  DisplayIcon          = $Icon
  InstallLocation      = $Dest
  InstallDate          = (Get-Date -Format 'yyyyMMdd')
  URLInfoAbout         = 'https://github.com/julianxyt/chess-drills'
  UninstallString      = $Uninstall
  QuietUninstallString = "$Uninstall -Quiet"
}
foreach ($k in $strings.Keys) { New-ItemProperty -Path $RegKey -Name $k -Value $strings[$k] -PropertyType String -Force | Out-Null }
foreach ($k in 'NoModify', 'NoRepair') { New-ItemProperty -Path $RegKey -Name $k -Value 1 -PropertyType DWord -Force | Out-Null }
New-ItemProperty -Path $RegKey -Name 'EstimatedSize' -Value $Size -PropertyType DWord -Force | Out-Null

Write-Host "Done. $AppName is in the Start menu$(if (-not $NoDesktop) { ' and on the desktop' })."
Write-Host 'Uninstall it from Settings > Apps > Installed apps.'

if (-not $NoLaunch) { Start-Process -FilePath $Browser -ArgumentList $LaunchArgs -WorkingDirectory $Dest }
