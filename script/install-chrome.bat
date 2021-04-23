@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (a:\_packer_config*.cmd) do @call "%%~i"
@if defined PACKER_DEBUG (@echo on) else (@echo off)

title Downloading and Installing Google Chrome.  Please wait...

if not exist "%SystemRoot%\_download.cmd" (
  echo ==^> ERROR: Unable to download Google Chrome due to missing download tool
  goto :exit1
)

if not defined PACKER_SEARCH_PATHS set PACKER_SEARCH_PATHS="%USERPROFILE%" a: b: c: d: e: f: g: h: i: j: k: l: m: n: o: p: q: r: s: t: u: v: w: x: y: z:

if not defined GOOGLE_CHROME_64_URL set GOOGLE_CHROME_64_URL=https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi
if not defined GOOGLE_CHROME_32_URL set GOOGLE_CHROME_32_URL=https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise.msi

goto :main

::::::::::::
:main
::::::::::::

if defined ProgramFiles(x86) (
  set GOOGLE_CHROME_URL=%GOOGLE_CHROME_64_URL%
) else (
  set GOOGLE_CHROME_URL=%GOOGLE_CHROME_32_URL%
)
set TEMP_PATH=%SystemRoot%\Temp
cd %TEMP_PATH%

call "%SystemRoot%\_download.cmd" "%GOOGLE_CHROME_URL%" "%TEMP_PATH%\google-chrome.msi"
if not exist "%TEMP_PATH%\google-chrome.msi" (
  echo ==^> ERROR: Unable to download file from %GOOGLE_CHROME_URL%
  goto exit1
)

for /r %%i in (google-chrome.msi) do if exist "%%~i" set GOOGLE_CHROME_EXE=%%~i

if not exist "%GOOGLE_CHROME_EXE%" echo ==^> ERROR: File not found: google-chrome.msi in "%TEMP_PATH%" & goto exit1

echo ==^> Installing Google Chrome
"%GOOGLE_CHROME_EXE%" /quiet /norestart

@if errorlevel 1 echo ==^> WARNING: Error %ERRORLEVEL% was returned by: "%GOOGLE_CHROME_EXE%" /quiet /norestart
ver>nul

popd

echo ==^> Removing "%GOOGLE_CHROME_EXE%"
del /q /s "%GOOGLE_CHROME_EXE%"

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
