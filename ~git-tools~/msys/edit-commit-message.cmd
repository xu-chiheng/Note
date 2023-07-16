@echo off

@set PATH="%MSYS2_DIR%\usr\bin";%PATH%
@set MSYSTEM=MSYS

cd ../..

@start bash.exe -i -c "do_git_edit_commit_message;"
