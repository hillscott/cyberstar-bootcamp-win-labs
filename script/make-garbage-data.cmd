@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (a:\_packer_config*.cmd) do @call "%%~i"
@if defined PACKER_DEBUG (@echo on) else (@echo off)

set "LICENSE_URL=https://upload.wikimedia.org/wikipedia/commons/d/df/Permiso_de_conducir_plastificado.jpg"
set "DOCS=C:\Users\vagrant\Documents"

echo ==^> Making some garbage data
echo Website-User-Password >"%DOCS%\passwords.txt"
echo RevenueAgency-SoccerManiac1-TomPass123 >>"%DOCS%\passwords.txt"
echo BestMovieDownloads-SoccerManiac1-TomPass123 >>"%DOCS%\passwords.txt"
echo Gmail-SoccerManiac1-TomPass123 >>"%DOCS%\passwords.txt"

echo name,url,username,password >"%DOCS%\firefox_passwords.csv"
echo hotdeals.com,http://hotdeals123456.com/login,james_bond,bondspassword123 >>"%DOCS%\firefox_passwords.csv"
echo dirtysiteexample123.com,http://dirtysiteexample123.com/login,james_bond,bondspassword123 >>"%DOCS%\firefox_passwords.csv"

echo Staffer,IdentityNumber,Address >"%DOCS%\staff_export.csv"
echo James Gomez Bond,123-45-6789,123 Nameless Spy St >>"%DOCS%\staff_export.csv"
echo Talia Bond,462-123-5678,123 Nameless Spy St >>"%DOCS%\staff_export.csv"

echo ==^> Pulling down example drivers license
call "%SystemRoot%\_download.cmd" "%LICENSE_URL%" "%DOCS%\scan1.jpg"

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


