@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (a:\_packer_config*.cmd) do @call "%%~i"
@if defined PACKER_DEBUG (@echo on) else (@echo off)

title Downloading and Scheduling uTorrent Install. Please wait...

if not exist "%SystemRoot%\_download.cmd" (
  echo ==^> ERROR: Unable to download uTorrent due to missing download tool
  goto :exit1
)

if not defined PACKER_SEARCH_PATHS set PACKER_SEARCH_PATHS="%USERPROFILE%" a: b: c: d: e: f: g: h: i: j: k: l: m: n: o: p: q: r: s: t: u: v: w: x: y: z:

if not defined UTORRENT_URL set UTORRENT_URL=https://download-hr.utorrent.com/track/stable/endpoint/utorrent/os/windows/uTorrent.exe

goto :main

::::::::::::
:main
::::::::::::

set TEMP_PATH=%SystemRoot%\Temp

cd %TEMP_PATH%
call "%SystemRoot%\_download.cmd" "%UTORRENT_URL%" "%TEMP_PATH%\uTorrent.exe"
if not exist "%TEMP_PATH%\uTorrent.exe" (
  echo ==^> ERROR: Unable to download file from %UTORRENT_URL%
  goto exit1
)

for /r %%i in (uTorrent.exe) do if exist "%%~i" set UTORRENT_EXE=%%~i

if not exist "%UTORRENT_EXE%" echo ==^> ERROR: File not found: uTorrent.exe in "%TEMP_PATH%" & goto exit1

if not exist A:\_install-uTorrent.py echo ==^> ERROR: File not found: _install-uTorrent.py & goto exit1
copy A:\_install-uTorrent.py %TEMP_PATH%\

if not exist "C:\Program Files\Python38\python.exe" echo ==^> ERROR: File not found: python.exe & goto exit1

set newMin=00
set newHour=08
rem Clear out spaces in our variables...
set newMin=%newMin: =%
set newHour=%newHour: =%

rem We use a scheduled task here because we need a GUI to pop-up.
rem Once it does so, pywinauto drives the install.
SCHTASKS /CREATE /SC ONCE /TN "BuildTasks\uTorrent" /TR "C:\PROGRA~1\Python38\python.exe %TEMP_PATH%\_install-uTorrent.py" /ST %newHour%:%newMin%

echo Fixing AC Power Issue...
powershell -NoProfile -Command "$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries; Set-ScheduledTask -TaskName BuildTasks\uTorrent -Settings $settings"

echo Start task via powershell manually...
powershell -NoProfile -Command "Start-ScheduledTask -TaskName BuildTasks\uTorrent"
@ping 127.0.0.1 -n 150

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
