@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (a:\_packer_config*.cmd) do @call "%%~i"
@if defined PACKER_DEBUG (@echo on) else (@echo off)

title Downloading and Installing GnuCash.  Please wait...

if not exist "%SystemRoot%\_download.cmd" (
  echo ==^> ERROR: Unable to download GnuCash due to missing download tool
  goto :exit1
)

if not defined PACKER_SEARCH_PATHS set PACKER_SEARCH_PATHS="%USERPROFILE%" a: b: c: d: e: f: g: h: i: j: k: l: m: n: o: p: q: r: s: t: u: v: w: x: y: z:
rem %28 = (
rem %29 = )
rem %20 = " "
if not defined GNUCASH_URL set "GNUCASH_URL=https://sourceforge.net/projects/gnucash/files/gnucash%%%%20%%%%28stable%%%%29/4.2/gnucash-4.2.setup.exe"

goto :main

::::::::::::
:main
::::::::::::

set TEMP_PATH=%SystemRoot%\Temp
cd %TEMP_PATH%
set SETUP_EXE=gnucash-4.2.setup.exe

call "%SystemRoot%\_download.cmd" "%GNUCASH_URL%" "%TEMP_PATH%\%SETUP_EXE%"
if not exist "%TEMP_PATH%\%SETUP_EXE%" (
  echo ==^> ERROR: Unable to download file from %GNUCASH_URL%
  goto exit1
)
for /r %%i in (%SETUP_EXE%) do if exist "%%~i" set GNUCASH_EXE=%%~i

if not exist "%GNUCASH_EXE%" echo ==^> ERROR: File not found: %SETUP_EXE% in "%TEMP_PATH%" & goto exit1

echo ==^> Installing GnuCash
"%GNUCASH_EXE%" /verysilent /norestart

@if errorlevel 1 echo ==^> WARNING: Error %ERRORLEVEL% was returned by: "%GNUCASH_EXE%" /verysilent /norestart
ver>nul

popd

echo ==^> Removing "%GNUCASH_EXE%"
del /q /s "%GNUCASH_EXE%"

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
