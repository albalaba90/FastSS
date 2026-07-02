@echo off
cls

net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

:menu
cls
echo ========================================
echo              SELECT OPTION
echo ========================================
echo.
echo   [1] DDFinder / Services
echo   [2] Mod Analyzers
echo   [3] Exit
echo.
choice /c 123 /n >nul

if errorlevel 3 goto exitapp
if errorlevel 2 goto modanalyzers
if errorlevel 1 goto ddfinder

:ddfinder
cls
echo Starting DDFinder / Services...
echo.

powershell -NoProfile -Command "Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/zedoonvm1/powershell-scripts/refs/heads/main/DoomsDayDetector.ps1')"

powershell -NoProfile -Command "$boot=(Get-CimInstance Win32_OperatingSystem).LastBootUpTime; $uptime=([datetime]$boot).ToString('yyyy-MM-dd HH:mm:ss'); $services='SysMain','PcaSvc','DPS','EventLog','Schedule','BAM','DusmSvc','Appinfo','CDPSvc','DcomLaunch','PlugPlay','WSearch','DiagTrack'; Write-Host 'SYSTEM STARTUP : ' -ForegroundColor DarkBlue -NoNewline; Write-Host $uptime; foreach($n in $services){ $s=Get-CimInstance Win32_Service | Where-Object { $_.Name -eq $n }; if($s){ if($s.ProcessId -gt 0){ $p=Get-Process -Id $s.ProcessId -ErrorAction SilentlyContinue; $t=if($p){$p.StartTime.ToString('yyyy-MM-dd HH:mm:ss')}else{'Running'} } else { $t=$s.State }; $color=if($s.StartMode -eq 'Disabled' -or $s.State -ne 'Running'){'Red'}else{'Green'}; Write-Host ($s.Name.PadRight(12)) -ForegroundColor Cyan -NoNewline; Write-Host ($s.DisplayName.PadRight(45)) -ForegroundColor $color -NoNewline; Write-Host ('| ' + $t) } }"

echo.
echo ========================================
echo              JAVA PROCESSES
echo ========================================
echo.

powershell -NoProfile -Command "$procs=Get-Process java,javaw -ErrorAction SilentlyContinue | Sort-Object StartTime; $line='+------------+----------+---------------------+----------------+'; if(-not $procs){ Write-Host '+-------------------------------------------------------------+'; Write-Host '| No java/javaw processes found.                              |'; Write-Host '+-------------------------------------------------------------+'; exit }; Write-Host $line; Write-Host ('| ' + 'Process'.PadRight(10) + ' | ' + 'PID'.PadRight(8) + ' | ' + 'Started'.PadRight(19) + ' | ' + 'Runtime'.PadRight(14) + ' |'); Write-Host $line; foreach($p in $procs){ $started=$p.StartTime.ToString('yyyy-MM-dd HH:mm:ss'); $runtime=('{0:dd\.hh\:mm\:ss}' -f ((Get-Date)-$p.StartTime)); Write-Host ('| ' + $p.ProcessName.PadRight(10) + ' | ' + ([string]$p.Id).PadRight(8) + ' | ' + $started.PadRight(19) + ' | ' + $runtime.PadRight(14) + ' |') }; Write-Host $line"

echo.
pause
goto menu

:modanalyzers
cls
echo Starting Mod Analyzers...
echo.

echo Starting YarpMod in a separate window...
start "YarpMod Analyzer" powershell -NoProfile -ExecutionPolicy Bypass -NoExit -Command "Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/YarpLetapStan/PowershellScripts/refs/heads/main/YarpsModAnalyzer6.0.ps1')"

echo Starting MeowMod in a separate window...
start "MeowMod Analyzer" powershell -NoProfile -ExecutionPolicy Bypass -NoExit -Command "Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/MeowTonynoh/MeowModAnalyzer/main/MeowModAnalyzer.ps1')"

echo.
echo Both analyzers launched.
echo.
pause
goto menu

:exitapp
cls
echo Exiting...
timeout /t 1 >nul
exit
