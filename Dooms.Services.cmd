@echo off
cls
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)
powershell -Command "gps java,javaw -ea 0 | ft ProcessName,Id,@{N='Started';E={$_.StartTime.ToString('yyyy-MM-dd HH:mm:ss')}},@{N='Runtime';E={('{0:dd\.hh\:mm\:ss}' -f ((Get-Date)-$_.StartTime))}} -AutoSize"
pause
