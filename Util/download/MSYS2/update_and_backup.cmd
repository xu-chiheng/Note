@echo off

@set PATH="%MSYS2_DIR%\usr\bin";%PATH%
@set MSYSTEM=MSYS

@start mintty.exe --exec bash -i update_and_backup.sh
