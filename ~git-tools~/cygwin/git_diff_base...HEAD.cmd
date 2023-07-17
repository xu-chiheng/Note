@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

cd ../..

@start bash -i -c "do_git_diff git_diff_branch...HEAD base;"
