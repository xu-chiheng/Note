@echo off

@set PATH="%MSYS2_DIR%\usr\bin";%PATH%
@set MSYSTEM=MSYS

cd ../..

@start mintty.exe --exec bash -i -c "time_command do_git_commit -S_merge_--squash; read;"
