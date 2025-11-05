@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

@start mintty.exe --hold=always --exec bash -i install_C.tom.sh
