@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (a:\_packer_config*.cmd) do @call "%%~i"
@if defined PACKER_DEBUG (@echo on) else (@echo off)

title Surfing to some garbage sites. Please wait...

if not defined PACKER_SEARCH_PATHS set PACKER_SEARCH_PATHS="%USERPROFILE%" a: b: c: d: e: f: g: h: i: j: k: l: m: n: o: p: q: r: s: t: u: v: w: x: y: z:

goto :main

::::::::::::
:main
::::::::::::

if not exist "C:\Program Files\Google\Chrome\Application\chrome.exe" echo ==^> ERROR: File not found: chrome.exe & goto exit1
if not exist "C:\Program Files\Python38\python.exe" echo ==^> ERROR: File not found: python.exe & goto exit1
if not exist "A:\_surf-garbage.py" echo ==^> ERROR: File not found: _surf-garbage.py
copy A:\_surf-garbage.py %TEMP_PATH%\

set newMin=00
set newHour=09
rem Remove spaces from variables...
set newMin=%newMin: =%
set newHour=%newHour: =%

rem We use a scheduled task here because we need a GUI to pop-up.
SCHTASKS /CREATE /SC ONCE /TN "BuildTasks\Sites" /TR "C:\PROGRA~1\Python38\python.exe %TEMP_PATH%\_surf-garbage.py" /ST %newHour%:%newMin%

echo Fixing AC Power Issue...
powershell -NoProfile -Command "$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries; Set-ScheduledTask -TaskName BuildTasks\Sites -Settings $settings"
rem echo "Waiting for task start / completion..."
echo Start task via powershell manually...
powershell -NoProfile -Command "Start-ScheduledTask -TaskName BuildTasks\Sites"
@ping 127.0.0.1 -n 60

ver>nul

popd

:exit0

@ping 127.0.0.1
@ver>nul

@goto :exit

:exit1

@ping 127.0.0.1
@verify other 2>nul

:exit

@echo ==^> Script exiting with errorlevel %ERRORLEVEL%
@exit /b %ERRORLEVEL%
