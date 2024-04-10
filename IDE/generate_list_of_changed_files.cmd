@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

@start mintty.exe --hold=always --exec bash -i generate_list_of_changed_files.sh.txt
