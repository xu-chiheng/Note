@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

@REM Visual Studio 2022 Enterprise
@REM https://learn.microsoft.com/en-us/visualstudio/releases/2022/release-history
@start mintty.exe --exec bash -i -c 'time_command windows_download_executable_from_url_and_execute vs2022_enterprise.exe https://aka.ms/vs/17/release/vs_enterprise.exe --layout vs2022 --all --arch all --lang en-US; read;'
