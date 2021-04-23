@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (a:\_packer_config*.cmd) do @call "%%~i"
@if defined PACKER_DEBUG (@echo on) else (@echo off)

echo ==^> Installing Garbage Extensions (Honey, Soccer All Stars Backgrounds)
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Google\Chrome\Extensions\bmnlcjabgnpnenekpadlanbbkooimhnj" /v update_url /t REG_SZ /d "https://clients2.google.com/service/update2/crx" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Google\Chrome\Extensions\ijlgjedhfhmokkanmhgagnppgkggnlfm" /v update_url /t REG_SZ /d "https://clients2.google.com/service/update2/crx" /f

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


