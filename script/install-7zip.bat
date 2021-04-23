@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (a:\_packer_config*.cmd) do @call "%%~i"
@if defined PACKER_DEBUG (@echo on) else (@echo off)

title Downloading and installing 7-zip.  Please wait...

if not exist "%SystemRoot%\_download.cmd" (
  echo ==^> ERROR: Unable to download UltraDefrag due to missing download tool
  goto :exit1
)

if not defined PACKER_SEARCH_PATHS set PACKER_SEARCH_PATHS="%USERPROFILE%" a: b: c: d: e: f: g: h: i: j: k: l: m: n: o: p: q: r: s: t: u: v: w: x: y: z:

if not defined SEVENZIP_32_URL set SEVENZIP_32_URL=https://www.7-zip.org/a/7z1900.exe
if not defined SEVENZIP_64_URL set SEVENZIP_64_URL=https://www.7-zip.org/a/7z1900-x64.exe

goto :main

::::::::::::
:install_sevenzip
::::::::::::

if defined ProgramFiles(x86) (
  set SEVENZIP_URL=%SEVENZIP_64_URL%
) else (
  set SEVENZIP_URL=%SEVENZIP_32_URL%
)

pushd .

set SEVENZIP_EXE=
set SEVENZIP_DLL=
for %%i in (7z.exe) do set SEVENZIP_EXE=%%~$PATH:i
if defined SEVENZIP_EXE goto return0

@for %%i in (%PACKER_SEARCH_PATHS%) do @if not defined SEVENZIP_EXE @if exist "%%~i\7z.exe" set SEVENZIP_EXE=%%~i\7z.exe

if not defined SEVENZIP_EXE goto get_sevenzip

@for %%i in (%PACKER_SEARCH_PATHS%) do @if not defined SEVENZIP_DLL @if exist "%%~i\7z.dll" set SEVENZIP_DLL=%%~i\7z.dll

if not defined SEVENZIP_DLL goto get_sevenzip

ver >nul
call :copy_sevenzip
if not errorlevel 1 goto return0

:get_sevenzip

for %%i in ("%SEVENZIP_URL%") do set SEVENZIP_EXE=%%~nxi
set SEVENZIP_DIR=%TEMP%\sevenzip
set SEVENZIP_PATH=%SEVENZIP_DIR%\%SEVENZIP_EXE%

echo ==^> Creating "%SEVENZIP_DIR%"
mkdir "%SEVENZIP_DIR%"
cd /d "%SEVENZIP_DIR%"

call "%SystemRoot%\_download.cmd" "%SEVENZIP_URL%" "%SEVENZIP_PATH%"
if errorlevel 1 (
  echo ==^> ERROR: Unable to download file from %SEVENZIP_URL%
  goto exit1
)

if not exist "%SEVENZIP_PATH%" goto return1

echo ==^> Installing "%SEVENZIP_PATH%"
%SEVENZIP_PATH% /S

@if errorlevel 1 echo ==^> WARNING: Error %ERRORLEVEL% was returned by: %SEVENZIP_PATH% /silent
ver>nul

set SEVENZIP_INSTALL_DIR=

for %%i in ("%ProgramFiles%" "%ProgramW6432%" "%ProgramFiles(x86)%") do if exist "%%~i\7-Zip" set SEVENZIP_INSTALL_DIR=%%~i\7-Zip

if exist "%SEVENZIP_INSTALL_DIR%" cd /D "%SEVENZIP_INSTALL_DIR%" & goto find_sevenzip

echo ==^> ERROR: Directory not found: "%ProgramFiles%\7-Zip"

goto return1

:find_sevenzip

set SEVENZIP_EXE=

for /r %%i in (7z.exe) do if exist "%%~i" set SEVENZIP_EXE=%%~i

if not exist "%SEVENZIP_EXE%" echo ==^> ERROR: Failed to unzip "%SEVENZIP_PATH%" & goto return1

set SEVENZIP_DLL=

for /r %%i in (7z.dll) do if exist "%%~i" set SEVENZIP_DLL=%%~i

if not exist "%SEVENZIP_DLL%" echo ==^> ERROR: Failed to unzip "%SEVENZIP_PATH%" & goto return1

:copy_sevenzip

echo ==^> Copying "%SEVENZIP_EXE%" to "%SystemRoot%"
copy /y "%SEVENZIP_EXE%" "%SystemRoot%\" || goto return1
copy /y "%SEVENZIP_DLL%" "%SystemRoot%\" || goto return1

:return0

popd
ver>nul

goto return

:return1

popd
verify other 2>nul

:return

goto :eof

::::::::::::
:main
::::::::::::

call :install_sevenzip
if errorlevel 1 goto exit1


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
