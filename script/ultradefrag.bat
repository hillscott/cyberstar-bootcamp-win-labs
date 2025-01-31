@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (a:\_packer_config*.cmd) do @call "%%~i"
@if defined PACKER_DEBUG (@echo on) else (@echo off)

title Downloading and running UltraDefrag to optimize the disk space usage of the image.  Please wait...

if not exist "%SystemRoot%\_download.cmd" (
  echo ==^> ERROR: Unable to download UltraDefrag due to missing download tool
  goto :exit1
)

if not defined PACKER_SEARCH_PATHS set PACKER_SEARCH_PATHS="%USERPROFILE%" a: b: c: d: e: f: g: h: i: j: k: l: m: n: o: p: q: r: s: t: u: v: w: x: y: z:

if not defined ULTRADEFRAG_32_URL set ULTRADEFRAG_32_URL=http://downloads.sourceforge.net/project/ultradefrag/stable-release/7.1.4/ultradefrag-portable-7.1.4.bin.i386.zip
if not defined ULTRADEFRAG_64_URL set ULTRADEFRAG_64_URL=http://downloads.sourceforge.net/project/ultradefrag/stable-release/7.1.4/ultradefrag-portable-7.1.4.bin.amd64.zip

goto :main

::::::::::::
:main
::::::::::::

if defined ProgramFiles(x86) (
  set ULTRADEFRAG_URL=%ULTRADEFRAG_64_URL%
) else (
  set ULTRADEFRAG_URL=%ULTRADEFRAG_32_URL%
)

for %%i in ("%ULTRADEFRAG_URL%") do set ULTRADEFRAG_ZIP=%%~nxi
set ULTRADEFRAG_DIR=%TEMP%\ultradefrag
set ULTRADEFRAG_PATH=%ULTRADEFRAG_DIR%\%ULTRADEFRAG_ZIP%

echo ==^> Creating "%ULTRADEFRAG_DIR%"
mkdir "%ULTRADEFRAG_DIR%"
pushd "%ULTRADEFRAG_DIR%"

call "%SystemRoot%\_download.cmd" "%ULTRADEFRAG_URL%" "%ULTRADEFRAG_PATH%"
if errorlevel 1 (
  echo ==^> ERROR: Unable to download file from %ULTRADEFRAG_URL%
  goto exit1
)

if not exist "%ULTRADEFRAG_PATH%" goto exit1

echo ==^> Unzipping "%ULTRADEFRAG_PATH%" to "%ULTRADEFRAG_DIR%"
7z e -y -o"%ULTRADEFRAG_DIR%" "%ULTRADEFRAG_PATH%" *\udefrag.exe *\*.dll

@if errorlevel 1 echo ==^> WARNING: Error %ERRORLEVEL% was returned by: 7z e -o"%ULTRADEFRAG_DIR%" "%ULTRADEFRAG_PATH%"
ver>nul

for /r %%i in (udefrag.exe) do if exist "%%~i" set ULTRADEFRAG_EXE=%%~i

if not exist "%ULTRADEFRAG_EXE%" echo ==^> ERROR: File not found: udefrag.exe in "%ULTRADEFRAG_DIR%" & goto exit1

echo ==^> Running UltraDefrag on %SystemDrive%
"%ULTRADEFRAG_EXE%" --optimize --repeat %SystemDrive%

@if errorlevel 1 echo ==^> WARNING: Error %ERRORLEVEL% was returned by: "%ULTRADEFRAG_EXE%" --optimize --repeat %SystemDrive%
ver>nul

popd

echo ==^> Removing "%ULTRADEFRAG_DIR%"
rmdir /q /s "%ULTRADEFRAG_DIR%"

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
