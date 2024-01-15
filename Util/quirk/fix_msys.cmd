@echo off

@set PATH="%MSYS2_DIR%\usr\bin";%PATH%
@set MSYSTEM=MSYS

@start mintty.exe --exec bash -i -c "time_command fix_system_quirks_one_time; read;"
