@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

@bash.exe -i -c "launch_browser_in_background chrome"
