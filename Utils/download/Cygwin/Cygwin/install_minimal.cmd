
call ../config.cmd

setup-x86.exe --local-install --quiet-mode --local-package-dir="%CD%" --categories=Archive,Base --packages="%PACKAGES%"

pause
