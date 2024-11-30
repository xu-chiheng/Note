
v6.2.0    44f28df24767cf9dca1ddc9b23157737c4cbb645    2021-12-14


v7.1.0    621da7789083b80d6f1ff1c0fb499334007b4f51    2022-08-30
patch_apply . ../_patch/qemu/backport-a.patch



backport-a.patch
Backport commit d9bb73d8e3a02135a34b2b7d7ba8f8e1e660a1e5 2023-03-19, Fix build on MinGW






[12/13/14/15 Regression] Error building GCC 12.1.0 against MinGW-w64: fatal error: cannot execute 'cc1': CreateProcess: No such file or directory
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105506




C:\Users\Administrator\Tool\qemu-mingw-ucrt-gcc-release-build\meson-logs\meson-log.txt

Build started at 2024-08-27T23:14:32.896560
Main binary: C:/Users/Administrator/Tool/qemu-mingw-ucrt-gcc-release-build/pyvenv/bin/python3.exe
Build Options: -Dprefix=C:/Users/Administrator/Tool/qemu-mingw-ucrt-gcc-release-install -Dgtk=enabled -Dsdl=enabled -Dwerror=false -Db_pie=false -Ddocs=disabled -Dplugins=true --native-file=config-meson.cross --native-file=C:/Users/Administrator/Tool/qemu/configs/meson/windows.txt
Python system: Windows
The Meson build system
Version: 1.2.3
Source dir: C:/Users/Administrator/Tool/qemu
Build dir: C:/Users/Administrator/Tool/qemu-mingw-ucrt-gcc-release-build
Build type: native build
Project name: qemu
Project version: 9.0.93
-----------
Detecting compiler via: `gcc -m64 --version` -> 0
stdout:
gcc (Rev5, Built by MSYS2 project) 13.2.0
Copyright (C) 2023 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
-----------
Running command: gcc -m64 -E -dM -

../qemu/meson.build:1:0: ERROR: Unable to detect GNU compiler type:
Compiler stdout:

-----
Compiler stderr:
gcc: fatal error: cannot execute 'cc1': CreateProcess: No such file or directory
compilation terminated.

-----

















gcc/gcc.cc
	      char *temp_spec = find_a_file (&exec_prefixes,
					     LTOPLUGINSONAME, R_OK,
					     false);
	      if (!temp_spec)
		fatal_error (input_location,
			     "%<-fuse-linker-plugin%>, but %s not found",
			     LTOPLUGINSONAME);
	      linker_plugin_file_spec = convert_white_space (temp_spec);




      errmsg = pex_run (pex,
			((i + 1 == n_commands ? PEX_LAST : 0)
			 | (string == commands[i].prog ? PEX_SEARCH : 0)),
			string, CONST_CAST (char **, commands[i].argv),
			NULL, NULL, &err);
      if (errmsg != NULL)
	{
	  errno = err;
	  fatal_error (input_location,
		       err ? G_("cannot execute %qs: %s: %m")
		       : G_("cannot execute %qs: %s"),
		       string, errmsg);
	}





../qemu/meson.build:1:0: ERROR: Unable to detect linker for compiler "gcc -m64 -mcx16 -Wl,--version -march=x86-64 -O3"
stdout:
stderr: gcc: fatal error: '-fuse-linker-plugin', but liblto_plugin.dll not found
compilation terminated.




meson/mesonbuild/compilers/detect.py


# GNU/Clang defines and version
# =============================

def _get_gnu_compiler_defines(compiler: T.List[str]) -> T.Dict[str, str]:
    """
    Detect GNU compiler platform type (Apple, MinGW, Unix)
    """
    # Arguments to output compiler pre-processor defines to stdout
    # gcc, g++, and gfortran all support these arguments
    args = compiler + ['-E', '-dM', '-']
    p, output, error = Popen_safe(args, write='', stdin=subprocess.PIPE)
    if p.returncode != 0:
        raise EnvironmentException('Unable to detect GNU compiler type:\n' + output + error)
    # Parse several lines of the type:
    # `#define ___SOME_DEF some_value`
    # and extract `___SOME_DEF`
    defines: T.Dict[str, str] = {}
    for line in output.split('\n'):
        if not line:
            continue
        d, *rest = line.split(' ', 2)
        if d != '#define':
            continue
        if len(rest) == 1:
            defines[rest[0]] = ''
        if len(rest) == 2:
            defines[rest[0]] = rest[1]
    return defines


../qemu/meson.build:1:0: ERROR: Unable to detect GNU compiler type:
gcc: fatal error: cannot execute 'cc1': CreateProcess: No such file or directory
compilation terminated.

