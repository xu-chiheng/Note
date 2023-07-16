@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

@start mintty --exec bash.exe -i update.sh
