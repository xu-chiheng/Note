@echo off

@set PATH="%MSYS2_DIR%\usr\bin";%PATH%
@set MSYSTEM=MSYS

@cd ../..

@start bash -i -c "do_git_diff git_diff_HEAD;"
