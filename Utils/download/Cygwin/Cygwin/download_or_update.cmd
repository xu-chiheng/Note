
call ../config.cmd

powershell -Command "(New-Object Net.WebClient).DownloadFile('https://www.cygwin.com/setup-x86.exe', 'setup-x86.exe')"
setup-x86.exe --download --quiet-mode --site="%SITE%" --local-package-dir="%CD%" --categories="%CATEGORIES%"
@rem --include-source

pause
