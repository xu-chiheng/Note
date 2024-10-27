@echo off

@set PATH="%MSYS2_DIR%\usr\bin";%PATH%
@set MSYSTEM=UCRT64

@cd ../..

@start mintty.exe --exec bash -i -c 'gitk --all'
