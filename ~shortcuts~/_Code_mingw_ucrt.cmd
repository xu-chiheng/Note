@echo off

@set PATH="%MSYS2_DIR%\usr\bin";%PATH%
@set MSYSTEM=UCRT64

@bash.exe -i -c 'windows_launch_vs_code_in_background'
