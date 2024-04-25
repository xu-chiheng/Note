
Issues:
MinGW GCC 14.0.0 can't build QEMU 7.1.0
MinGW Clang does not show git revision
Cygwin GCC can't build debug mode llvm using "./build-llvm.sh GCC Debug shared"



[ 98%] Built target clang-tidy
collect2: error: ld returned 1 exit status
make[2]: *** [tools/clang/tools/clang-shlib/CMakeFiles/clang-cpp.dir/build.make:1961: bin/cygclang-cpp-18git.dll] Error 1
make[2]: Leaving directory '/cygdrive/e/Note/Tool/llvm-gcc-debug-build'
make[1]: *** [CMakeFiles/Makefile2:45838: tools/clang/tools/clang-shlib/CMakeFiles/clang-cpp.dir/all] Error 2
make[1]: *** Waiting for unfinished jobs....
make[2]: Leaving directory '/cygdrive/e/Note/Tool/llvm-gcc-debug-build'
[ 98%] Built target clangDaemon
make[1]: Leaving directory '/cygdrive/e/Note/Tool/llvm-gcc-debug-build'
make: *** [Makefile:156: all] Error 2








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

