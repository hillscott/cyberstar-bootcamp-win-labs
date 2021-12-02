@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (a:\_packer_config*.cmd) do @call "%%~i"
@if defined PACKER_DEBUG (@echo on) else (@echo off)

title Downloading and Installing GnuCash.  Please wait...

if not exist "%SystemRoot%\_download.cmd" (
  echo ==^> ERROR: Unable to download qBittorrent due to missing download tool
  goto :exit1
)

if not defined PACKER_SEARCH_PATHS set PACKER_SEARCH_PATHS="%USERPROFILE%" a: b: c: d: e: f: g: h: i: j: k: l: m: n: o: p: q: r: s: t: u: v: w: x: y: z:
rem %28 = (
rem %29 = )
rem %20 = " "
if not defined QBIT_URL set "QBIT_URL=https://sourceforge.net/projects/qbittorrent/files/qbittorrent-win32/qbittorrent-4.3.9/qbittorrent_4.3.9_x64_setup.exe"

goto :main

::::::::::::
:main
::::::::::::

set TEMP_PATH=%SystemRoot%\Temp
cd %TEMP_PATH%
set SETUP_EXE=qbittorrent_4.3.9_x64_setup.exe

call "%SystemRoot%\_download.cmd" "%QBIT_URL%" "%TEMP_PATH%\%SETUP_EXE%"
if not exist "%TEMP_PATH%\%SETUP_EXE%" (
  echo ==^> ERROR: Unable to download file from %QBIT_URL%
  goto exit1
)
for /r %%i in (%SETUP_EXE%) do if exist "%%~i" set QBIT_EXE=%%~i

if not exist "%QBIT_EXE%" echo ==^> ERROR: File not found: %SETUP_EXE% in "%TEMP_PATH%" & goto exit1

echo ==^> Installing qBittorrent
"%QBIT_EXE%" /S

@if errorlevel 1 echo ==^> WARNING: Error %ERRORLEVEL% was returned by: "%QBIT_EXE%" /S
ver>nul

popd

echo ==^> Removing "%QBIT_EXE%"
del /q /s "%QBIT_EXE%"

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
