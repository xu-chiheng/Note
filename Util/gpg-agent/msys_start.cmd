@echo off

@set PATH="%MSYS2_DIR%\usr\bin";%PATH%
@set MSYSTEM=MSYS

@start mintty.exe --exec bash -i -c "gpg_agent_start_in_background"
