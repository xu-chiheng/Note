@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

@REM Visual Studio 2026 Enterprise
@REM https://learn.microsoft.com/en-us/visualstudio/releases/2026/release-history
@REM Stable	18.3.3	March 10, 2026
@start mintty.exe --exec bash -i -c ^
'time_command windows_download_executable_from_url_and_execute vs2026_enterprise.exe ^
https://download.visualstudio.microsoft.com/download/pr/c7f9c40d-5956-4fa0-bd04-b866c2461198/0429e4accf8513ee5bf3955d4aaf6bf833d468cbeebb103536c561f0e17c27c5/vs_Enterprise.exe ^
--layout vs2026 --all --arch all --lang en-US; read;'
