@echo off

@REM Add /ucrt64/bin only for wish command
@set PATH="%MSYS2_DIR%\ucrt64\bin";"%MSYS2_DIR%\usr\bin";%PATH%
@set MSYSTEM=MSYS

@cd ../..

@start mintty.exe --exec bash -i -c gitk
