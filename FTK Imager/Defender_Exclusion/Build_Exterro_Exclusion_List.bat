REM Please provide INSTALL DIRECTORY as first argument for this bat file always and followed by folder paths to be excluded like STATE,TEMP,PG_DATA,CASE,Evidence folders  etc.,
@ECHO off
set InstallDir=%1
echo -Folder >> "C:\Program Files\AccessData\FTK Imager\Defender_Exclusion\ExterroExclusions.txt"
setlocal enabledelayedexpansion
for %%i in (%*) do (		
	set "temp=%%~i"
	IF "!temp:~-1!"=="\" SET temp=!temp:~,-1!
	echo !temp! >> "C:\Program Files\AccessData\FTK Imager\Defender_Exclusion\ExterroExclusions.txt"
)
endlocal
echo -Process >> "C:\Program Files\AccessData\FTK Imager\Defender_Exclusion\ExterroExclusions.txt"
Rem Pause
if exist %InstallDir% (
cd /d %InstallDir%
dir *.exe /s /b sortorder:N >> "C:\Program Files\AccessData\FTK Imager\Defender_Exclusion\ExterroExclusions.txt"
;
)
exit 0;