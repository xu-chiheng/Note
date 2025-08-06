@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

@REM https://learn.microsoft.com/en-us/visualstudio/install/create-an-offline-installation-of-visual-studio
@REM https://learn.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio
@REM Visual Studio 2022 Enterprise
@start mintty.exe --exec bash -i -c 'echo_command rm -rf vslayout; time_command windows_download_executable_from_url_and_execute vs_enterprise.exe https://aka.ms/vs/17/release/vs_enterprise.exe --layout vslayout --all --arch all --lang en-US; read;'
