@echo off

@set PATH="%MSYS2_DIR%\mingw64\bin";"%MSYS2_DIR%\usr\bin";%PATH%
@set MSYSTEM=MINGW64

@start mintty.exe --exec bash -i
