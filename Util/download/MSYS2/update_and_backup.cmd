@echo off

@set PATH="%MSYS2_DIR%\usr\bin";%PATH%
@set MSYSTEM=MSYS

@start mintty.exe --exec bash -i -c "msys2_update_and_backup; read;"
