@echo off

@set PATH="%MSYS2_DIR%\usr\bin";%PATH%
@set MSYSTEM=MINGW64

@cd ../..

@start mintty.exe --exec bash -i -c 'gitk --all'
