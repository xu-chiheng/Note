@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

@cd ../..

@start bash.exe -i -c "do_git_edit_commit_message;"
