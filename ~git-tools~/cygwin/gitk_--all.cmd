@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

@cd ../..

@start mintty.exe --exec bash -i -c 'startxwin "$(which gitk)" --all'
