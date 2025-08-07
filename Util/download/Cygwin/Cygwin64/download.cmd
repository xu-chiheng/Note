

@REM set SITE=https://mirrors.163.com/cygwin
@REM set SITE=https://mirrors.aliyun.com/cygwin
@REM set SITE=https://mirrors.ustc.edu.cn/cygwin
set SITE=https://mirrors.tuna.tsinghua.edu.cn/cygwin
@REM set SITE=https://mirrors.sohu.com/cygwin
@REM gitk needs X11
set CATEGORIES=Admin,Archive,Base,Devel,Doc,Editors,Interpreters,Libs,Net,Perl,Python,Security,Shells,System,Tcl,Text,Utils,X11

curl -L -o setup-x86_64.exe https://www.cygwin.com/setup-x86_64.exe
setup-x86_64.exe --download --quiet-mode --site="%SITE%" --local-package-dir="%CD%" --categories="%CATEGORIES%"
@REM --include-source

pause
