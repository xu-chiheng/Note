@echo off

@call "%VS2022_DIR%\VC\Auxiliary\Build\vcvarsall.bat" x64
@set PATH=%PATH%;"%VCPKG_DIR%";"%MSYS2_DIR%\usr\bin"
@set MSYSTEM=MSYS

@start mintty.exe --exec bash -i
