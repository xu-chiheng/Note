@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

@start mintty.exe --hold=always --exec bash -i remove_unneeded_plug-ins.sh.txt
