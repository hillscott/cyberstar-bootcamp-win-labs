@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (a:\_packer_config*.cmd) do @call "%%~i"
@if defined PACKER_DEBUG (@echo on) else (@echo off)

title Downloading and running SysInternals' SDelete to optimize the empty space of the image.  Please wait...

if not exist "%SystemRoot%\_download.cmd" (
    echo ==^> ERROR: Unable to download SysInternals' SDelete due to missing download tool
    goto :exit1
)

if not defined SDELETE_URL set SDELETE_URL=https://download.sysinternals.com/files/SDelete.zip

if defined ProgramFiles(x86) (
  set SDELETE_EXE=sdelete64.exe
) else (
  set SDELETE_EXE=sdelete.exe
)
set SDELETE_DIR=%TEMP%\sdelete
set SDELETE_ARCHIVE=SDelete.zip
set SDELETE_PATH=%SDELETE_DIR%\%SDELETE_EXE%

rem Enable the below if you run into NTFS MFT File hangs
rem echo ==^> Fixing NTFS Compression Bug in SDELETE
rem set TEMP_ESCAPED=%TEMP:\=\\%
rem echo %TEMP_ESCAPED%
rem powershell -NoProfile -Command {$file = Get-WmiObject -Query ""SELECT * FROM CIM_DataFile WHERE Name=%TEMP_ESCAPED%""; $file.Compress()}

echo ==^> Creating "%SDELETE_DIR%"
mkdir "%SDELETE_DIR%"
pushd "%SDELETE_DIR%"

call "%SystemRoot%\_download.cmd" "%SDELETE_URL%" "%SDELETE_ARCHIVE%"
if errorlevel 1 (
  echo ==^> ERROR: Unable to download file from %SDELETE_URL%
  goto exit1
)

if not exist "%SDELETE_ARCHIVE%" goto exit1
echo ==^> Unzipping "%SDELETE_ARCHIVE%" to "%SDELETE_DIR%"
7z e -y -o"%SDELETE_DIR%" "%SDELETE_ARCHIVE%"

@if errorlevel 1 echo ==^> WARNING: Error %ERRORLEVEL% was returned by: 7z e -o"%SDELETE_DIR%" "%SDELETE_PATH%"

reg add HKCU\Software\Sysinternals\SDelete /v EulaAccepted /t REG_DWORD /d 1 /f
echo ==^> Running SDelete on %SystemDrive%
"%SDELETE_PATH%" -z %SystemDrive%

@if errorlevel 1 echo ==^> WARNING: Error %ERRORLEVEL% was returned by: "%SDELETE_PATH%" -z %SystemDrive%
ver>nul

popd

echo ==^> Removing "%SDELETE_DIR%"
rmdir /q /s "%SDELETE_DIR%"

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
