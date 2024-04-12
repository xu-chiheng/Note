@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

@start bash.exe -i -c "find . -mindepth 1 -maxdepth 1 -type d -print0 | xargs -0 rm -rf"
