@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (a:\_packer_config*.cmd) do @call "%%~i"
@if defined PACKER_DEBUG (@echo on) else (@echo off)

title Downloading and Installing Python.  Please wait...

if not exist "%SystemRoot%\_download.cmd" (
  echo ==^> ERROR: Unable to download Python due to missing download tool
  goto :exit1
)

if not defined PACKER_SEARCH_PATHS set PACKER_SEARCH_PATHS="%USERPROFILE%" a: b: c: d: e: f: g: h: i: j: k: l: m: n: o: p: q: r: s: t: u: v: w: x: y: z:

if not defined PYTHON_64_URL set PYTHON_64_URL=https://www.python.org/ftp/python/3.8.5/python-3.8.5-amd64.exe
if not defined PYTHON_32_URL set PYTHON_32_URL=https://www.python.org/ftp/python/3.8.5/python-3.8.5.exe

goto :main

::::::::::::
:main
::::::::::::

if defined ProgramFiles(x86) (
  set PYTHON_URL=%PYTHON_64_URL%
) else (
  set PYTHON_URL=%PYTHON_32_URL%
)
set TEMP_PATH=%SystemRoot%\Temp
cd %TEMP_PATH%

call "%SystemRoot%\_download.cmd" "%PYTHON_URL%" "%TEMP_PATH%\python.exe"
if not exist "%TEMP_PATH%\python.exe" (
  echo ==^> ERROR: Unable to download file from %PYTHON_URL%
  goto exit1
)

for /r %%i in (python.exe) do if exist "%%~i" set PYTHON_EXE=%%~i

if not exist "%PYTHON_EXE%" echo ==^> ERROR: File not found: python.exe in "%TEMP_PATH%" & goto exit1

echo ==^> Installing Python
"%PYTHON_EXE%" /quiet InstallAllUsers=1 PrependPath=1 Include_test=0

@if errorlevel 1 echo ==^> WARNING: Error %ERRORLEVEL% was returned by: "%PYTHON_EXE%" /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
ver>nul

popd

echo ==^> Removing "%PYTHON_EXE%"
del /q /s "%PYTHON_EXE%"

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
