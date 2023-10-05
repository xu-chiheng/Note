@echo off

@set PATH="%MSYS2_DIR%\ucrt64\bin";"%MSYS2_DIR%\usr\bin";%PATH%
@set MSYSTEM=UCRT64

@start mintty.exe --exec bash -i -c "make uninstall; make install; echo completed; read;"
