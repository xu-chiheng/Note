@echo off

@call "%VS_DIR%\VC\Auxiliary\Build\vcvarsall.bat" x64
@set PATH=%PATH%;"%CYGWIN_DIR%\bin"

@bash.exe -i -c 'windows_launch_vs_code_in_background'
