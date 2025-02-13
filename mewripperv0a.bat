@echo off
setlocal enabledelayedexpansion

:: Run as Administrator
net file >nul 2>&1 || (powershell -Command "Start-Process -FilePath '%~0' -Verb RunAs" && exit)

:: Set Power Plan to "Power Saver"
powercfg /setactive a1841308-3541-4fab-bc81-f71556f20b4a

:: Enable Deep Link Power Sharing (Intel Arc + CPU dynamic power allocation)
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power" /v "DeepLinkPowerShare" /t REG_DWORD /d 1 /f

:: Reduce Intel Arc Power Consumption
:: 1. Lower power limit to 35W (adjust as needed)
:: 2. Set GPU frequency cap to reduce battery drain
"C:\Program Files\Intel\IGCC\igfxcmd.exe" set powerlimit 35
"C:\Program Files\Intel\IGCC\igfxcmd.exe" set freq 900

:: CPU Throttling to Max 50%
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 50

:: Reduce Screen Brightness (requires NirCmd)
nircmd.exe setbrightness 30

:: Kill Background Apps
taskkill /f /im chrome.exe /im msedge.exe /im discord.exe /im steam.exe

:: Disable Startup Programs
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /va /f

echo Optimization complete. Arc is now in low-power mode.
pause
