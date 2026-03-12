@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

@bash.exe -i -c "windows_sync_time"

pause
