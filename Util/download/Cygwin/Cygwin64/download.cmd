
call ../config.cmd

powershell -Command "(New-Object Net.WebClient).DownloadFile('https://www.cygwin.com/setup-x86_64.exe', 'setup-x86_64.exe')"
setup-x86_64.exe --download --quiet-mode --site="%SITE%" --local-package-dir="%CD%" --categories="%CATEGORIES%"
@REM --include-source

pause
