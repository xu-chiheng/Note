@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

@bash.exe -i -c "time_command sync"

pause
