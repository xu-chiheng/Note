@echo off

@REM Add /mingw64/bin only for connect command
@set PATH="%MSYS2_DIR%\mingw64\bin";"%MSYS2_DIR%\usr\bin";%PATH%
@set MSYSTEM=MSYS

cd ../..

@start mintty.exe --exec bash -i -c "time_command do_git_misc git_pull_--rebase upstream; read;"
