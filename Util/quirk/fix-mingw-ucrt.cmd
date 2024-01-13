@echo off

@set PATH="%MSYS2_DIR%\ucrt64\bin";"%MSYS2_DIR%\usr\bin";%PATH%
@set MSYSTEM=UCRT64

@start mintty.exe --exec bash -i -c "time_command fix_system_quirks_one_time; read;"
