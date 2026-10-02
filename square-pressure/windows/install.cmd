@echo off
rem Double-click to install Square Pressure for this Windows user.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" %*
if errorlevel 1 pause
