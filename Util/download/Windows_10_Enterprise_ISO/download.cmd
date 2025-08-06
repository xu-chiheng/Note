@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

@REM https://www.microsoft.com/en-us/software-download/windows10
@REM replace zh-CN with en-US to download English version
@start mintty.exe --exec bash -i -c 'time_command windows_download_executable_from_url_and_execute MediaCreationTool_22H2.exe https://go.microsoft.com/fwlink/?LinkId=2265055 /Eula Accept /Retail /MediaArch x64 /MediaLangCode zh-CN /MediaEdition Enterprise; read;'

@REM Win10_22H2_Enterprise_en-US_x64_202210.iso
@REM Win10_22H2_Enterprise_zh-CN_x64_202210.iso
