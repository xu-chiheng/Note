@echo off

@REM Add /mingw64/bin only for gitk command
@set PATH="%MSYS2_DIR%\mingw64\bin";"%MSYS2_DIR%\usr\bin";%PATH%
@set MSYSTEM=MSYS

@cd ../..

@start mintty.exe --exec bash -i -c 'gitk --all'
