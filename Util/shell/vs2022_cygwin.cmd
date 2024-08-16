@echo off

@call "%VS2022_DIR%\VC\Auxiliary\Build\vcvarsall.bat" x64
@set PATH=%PATH%;"%CYGWIN_DIR%\bin"

@start mintty.exe --exec bash -i
