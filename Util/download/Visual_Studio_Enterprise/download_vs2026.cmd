@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

@REM Visual Studio 2026 Enterprise
@REM https://learn.microsoft.com/en-us/visualstudio/releases/2026/release-history
@start mintty.exe --exec bash -i -c 'time_command windows_download_executable_from_url_and_execute vs2026_enterprise.exe https://download.visualstudio.microsoft.com/download/pr/6efb3484-905b-485c-8b5f-9d3a5f39e731/f8f255789e97b097c98b9d1b214c3a4a9ea3a0d4dc5528d4942dff134ad32c83/vs_Enterprise.exe --layout vs2026 --all --arch all --lang en-US; read;'
