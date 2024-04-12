@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

@start bash.exe -i -c "remove_all_dirs_in_current_dir"
