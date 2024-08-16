@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

cd ../..

@start mintty.exe --exec bash -i -c "time_command do_git_misc git_pull_--rebase; read;"
