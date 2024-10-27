@echo off

@set PATH="%MSYS2_DIR%\usr\bin";%PATH%
@set MSYSTEM=MINGW64

@start mintty.exe --exec bash -i -c "time_command fix_system_quirks_one_time; read;"
