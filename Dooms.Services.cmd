@echo off
cls
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)
powershell -NoProfile -Command "Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/zedoonvm1/powershell-scripts/refs/heads/main/DoomsDayDetector.ps1')" & powershell -NoProfile -Command "$boot=(Get-CimInstance Win32_OperatingSystem).LastBootUpTime; $uptime=([datetime]$boot).ToString('yyyy-MM-dd HH:mm:ss'); $services='SysMain','PcaSvc','DPS','EventLog','Schedule','BAM','DusmSvc','Appinfo','CDPSvc','DcomLaunch','PlugPlay','WSearch','DiagTrack'; Write-Host 'SYSTEM STARTUP : ' -ForegroundColor DarkBlue -NoNewline; Write-Host $uptime; foreach($n in $services){ $s=Get-CimInstance Win32_Service | Where-Object { $_.Name -eq $n }; if($s){ if($s.ProcessId -gt 0){ $p=Get-Process -Id $s.ProcessId -ErrorAction SilentlyContinue; $t=if($p){$p.StartTime.ToString('yyyy-MM-dd HH:mm:ss')}else{'Running'} } else { $t=$s.State }; $color=if($s.StartMode -eq 'Disabled' -or $s.State -ne 'Running'){'Red'}else{'Green'}; Write-Host ($s.Name.PadRight(12)) -ForegroundColor Cyan -NoNewline; Write-Host ($s.DisplayName.PadRight(45)) -ForegroundColor $color -NoNewline; Write-Host ('| ' + $t) } }" & powershell -Command "gps java,javaw -ea 0 | ft ProcessName,Id,@{N='Started';E={$_.StartTime.ToString('yyyy-MM-dd HH:mm:ss')}},@{N='Runtime';E={('{0:dd\.hh\:mm\:ss}' -f ((Get-Date)-$_.StartTime))}} -AutoSize"
pause