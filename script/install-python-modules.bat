@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (a:\_packer_config*.cmd) do @call "%%~i"
@if defined PACKER_DEBUG (@echo on) else (@echo off)

title Installing Pywinauto.  Please wait...

if not defined PACKER_SEARCH_PATHS set PACKER_SEARCH_PATHS="%USERPROFILE%" a: b: c: d: e: f: g: h: i: j: k: l: m: n: o: p: q: r: s: t: u: v: w: x: y: z:

goto :main

::::::::::::
:main
::::::::::::

set TEMP_PATH=%SystemRoot%\Temp
cd %TEMP_PATH%

echo ==^> Installing Pywinauto...
pip install -U pywinauto 

@if errorlevel 1 echo ==^> WARNING: Error %ERRORLEVEL% was returned by: pip install -U pywinauto
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
