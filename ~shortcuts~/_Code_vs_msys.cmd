@echo off

@call "%VS_DIR%\VC\Auxiliary\Build\vcvarsall.bat" x64
@set PATH=%PATH%;"%MSYS2_DIR%\usr\bin"
@set MSYSTEM=MSYS

@bash.exe -i -c 'windows_launch_vs_code_in_background'
