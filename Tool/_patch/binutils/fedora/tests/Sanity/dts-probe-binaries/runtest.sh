#!/bin/bash
# vim: dict=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   runtest.sh of /tools/binutils/Sanity/dts-probe-binaries
#   Description: Toolset binutils on system/toolset built binaries.
#   Author: Marek Polacek <polacek@redhat.com>
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   Copyright (c) 2012 Red Hat, Inc. All rights reserved.
#
#   This copyrighted material is made available to anyone wishing
#   to use, modify, copy, or redistribute it subject to the terms
#   and conditions of the GNU General Public License version 2.
#
#   This program is distributed in the hope that it will be
#   useful, but WITHOUT ANY WARRANTY; without even the implied
#   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#   PURPOSE. See the GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public
#   License along with this program; if not, write to the Free
#   Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
#   Boston, MA 02110-1301, USA.
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Include Beaker environment
. /usr/share/beakerlib/beakerlib.sh || exit 1

PACKAGES=(gdb gcc gcc-c++ binutils gawk grep)

# Choose the binaries.
GCC=${GCC:-gcc}
GXX=${GXX:-g++}
GDB=${GDB:-gdb}
AR=${AR:-ar}
ADDR2LINE=${ADDR2LINE:-addr2line}
CXXFILT=${CXXFILT:-c++filt}
ELFEDIT=${ELFEDIT:-elfedit}
NM=${NM:-nm}
OBJCOPY=${OBJCOPY:-objcopy}
OBJDUMP=${OBJDUMP:-objdump}
READELF=${READELF:-readelf}
SIZE=${SIZE:-size}
STRINGS=${STRINGS:-strings}

rlJournalStart
  rlPhaseStartSetup
    for p in "${PACKAGES[@]}"; do
      rlAssertRpm "$p"
    done; unset p
    rlRun "TmpDir=\$(mktemp -d)" 0 "Creating tmp directory"
    # Copy the GDB commands file and testcase.
    rlRun "cp -v check-localplt.c m.c popcnt.c virtual2.C $TmpDir"
    rlRun "pushd $TmpDir"
  rlPhaseEnd

  rlPhaseStartTest "Prepare a binary."
    # Compile a test case.
    rlRun "$GCC -O2 -g -std=gnu99 check-localplt.c -o localplt"
    rlAssertExists "localplt"
  rlPhaseEnd

  rlPhaseStartTest "Test ar."
    # Test --help.
    rlRun "$AR --help"

    # We need a few ET_RELs.
    rlRun "$GCC -O2 -g -std=gnu99 -c -o a.o -xc - <<< 'int a(int a){return a^2;}'"
    rlAssertExists "a.o"
    rlRun "$GCC -O2 -g -std=gnu99 -c -o b.o -xc - <<< 'int b(int a){return a&2;}'"
    rlAssertExists "b.o"
    rlRun "$GCC -O2 -g -std=gnu99 -c -o c.o -xc - <<< 'int c(int a){return a|2;}'"
    rlAssertExists "c.o"
    rlRun "$GCC -O2 -g -std=gnu99 -c -o d.o -xc - <<< 'int d(int a){return a%2;}'"
    rlAssertExists "d.o"

    # Test that we can create a static library.
    rlRun "$AR crsv abc.a a.o b.o c.o"
    rlAssertExists "abc.a"

    # ...and use this library.
    rlRun "$GCC -O2 -Wall -std=gnu99 m.c abc.a -o abc"
    rlRun "./abc" 2
    
    # Test -t option.
    rlRun "$AR t abc.a > ar-t.out"
    printf "a.o\nb.o\nc.o\n" > ar-t
    rlAssertNotDiffer ar-t ar-t.out

    # Test -d option.
    rlRun "$AR d abc.a c.o"
    rlRun "$AR t abc.a > ar-t.out"
    printf "a.o\nb.o\n" > ar-t
    rlAssertNotDiffer ar-t ar-t.out

    # Test -r option.
    rlRun "$AR r abc.a d.o"
    rlRun "$AR t abc.a > ar-t.out"
    printf "a.o\nb.o\nd.o\n" > ar-t
    rlAssertNotDiffer ar-t ar-t.out
  rlPhaseEnd

  rlPhaseStartTest "Test addr2line."
    rlRun "$ADDR2LINE --help"
    # Compile a testcase.
    rlRun "$GCC -g3 -Wall -O2 -o popcnt popcnt.c"
    # Save the address where main resides.
    ./popcnt > a
    rlRun "$ADDR2LINE -e popcnt $(cat a) > r"
    # We know that main is at line 4.  But on PPC we get ??:0...
if test ! $(uname -m) = "ppc64"; then
    rlAssertGrep "popcnt.c:4" r
fi
    rm -vf [ra]
  rlPhaseEnd

  rlPhaseStartTest "Test c++filt."
    rlRun "$CXXFILT --help"
    # Compile a testcase.
    rlRun "$GXX -g -O0 virtual2.C -o virt"
    rlRun "$NM virt | $CXXFILT &> f"
    rlLogInfo "===== f"
    rlLogInfo "$(cat f)"
    rlLogInfo "====="
    rlAssertGrep "A::~A()" f
    rlAssertGrep "B::~B()" f
    rlAssertGrep "typeinfo for A" f
    rlAssertGrep "typeinfo for B" f
    rlAssertGrep "typeinfo name for A" f
    rlAssertGrep "typeinfo name for B" f
    rlAssertGrep "vtable for A" f
    rlAssertGrep "vtable for B" f
    rlAssertGrep "operator delete(void\*)" f
    rlRun "grep -E 'operator new\(unsigned (long|int)\)' f"
    rlRun "$CXXFILT -n _Z1ft > f"
    # Create test file.
    echo "f(unsigned short)" > F
    rlAssertNotDiffer F f
    rm -vf [Ff]
  rlPhaseEnd

  rlPhaseStartTest "Test elfedit."
    rlRun "$ELFEDIT --help"
    # Change the Ehdr somewhat.
    rlRun "$ELFEDIT --output-osabi=TRU64 virt"
    rlRun "$ELFEDIT --output-type=rel virt"
    rlRun "$READELF -Wh virt > r"
    rlAssertGrep "UNIX - TRU64" r
    rlAssertGrep "REL (Relocatable file)" r
    # Ok, back to normal.
    rlRun "$ELFEDIT --output-osabi=none virt"
    rlRun "$ELFEDIT --output-type=exec virt"
    rlRun "$READELF -Wh virt > r"
    rlAssertGrep "UNIX - System V" r
    rlAssertGrep "EXEC (Executable file)" r
    rm -vf r
  rlPhaseEnd

  rlPhaseStartTest "Test nm."
    rlRun "$NM --help"
    # Try --debug-syms.
    rlRun "$NM --debug-syms virt | gawk '{ print \$2 \" \" \$3 }' > o"
    rlLogInfo "$(cat o)"
    rlAssertGrep "completed" o
    if [ "`rlGetPrimaryArch`" != "s390x" ] || [ ! rlIsRHEL 7 ]; then
        rlAssertGrep "virtual2.C" o
    fi
    rlAssertGrep "_ZN1BD1Ev" o
    # On PPC, we have .toc instead.
    if [ "$(rlGetPrimaryArch)" != "ppc64" ] && [ "$(rlGetPrimaryArch)" != "ppc64le" ]; then
        rlAssertGrep "_GLOBAL_OFFSET_TABLE_" o
    fi
    # Try -u.
    rlRun "$NM -u popcnt > u"
    rlAssertGrep "printf@GLIBC" u
    if [ "`rlGetPrimaryArch`" != "ppc64" ] || [ ! rlIsRHEL 7 ]; then
        rlAssertGrep "__gmon_start__" u
    fi
    rlAssertGrep "__libc_start_main@GLIBC" u
    # Try -P --size-sort.
    rlRun "$NM -P --size-sort localplt > p"
if test $(uname -m) = "ppc64" -a $(rlGetDistroRelease) -gt 5; then
    rlAssertGrep "main D" p
else
    rlAssertGrep "main T" p
fi
    rlAssertGrep "completed.* b" p
    rlAssertGrep "_IO_stdin_used R" p
    # Try --defined-only --print-size.
    rlRun "$NM --defined-only --print-size localplt > d"
    rm -vf [oupd]
  rlPhaseEnd

  rlPhaseStartTest "Test objcopy."
    rlRun "$OBJCOPY --help"

    cp -v virt xvirt
    rlRun "$OBJCOPY --only-section=.shstrtab xvirt"
    rlRun "$READELF -WS xvirt > x"
    rlAssertGrep ".shstrtab" x

    # Try to delete .interp section.
    cp -v virt virt2
    rlRun "$OBJCOPY -R .interp virt2"
    rlRun "$READELF -WS virt2 > i"
    rlAssertNotGrep ".interp" i

    rm -vf [vcx] xvirt zvirt
  rlPhaseEnd

  rlPhaseStartTest "Test objdump."
    rlRun "$OBJDUMP --help"
    # Just try to run with -f.
    rlRun "$OBJDUMP -f virt"
    # Just try to run with -x.
    rlRun "$OBJDUMP -wx virt"
    # -dr.  No good way how to compare this.
    rlRun "$OBJDUMP -dr virt > d"
    rlAssertGrep "Disassembly of section .text:" d
    rlAssertGrep "_start" d
    rlAssertGrep "main" d

    # -T.
    rlRun "$OBJDUMP -T virt > t"
    rlAssertGrep "abort" t

    # -R.
    rlRun "$OBJDUMP -R virt > R"
    rlAssertGrep "abort" R

    # -Wl.
    rlRun "$OBJDUMP -Wl virt > w"
    rlAssertGrep "Extended opcode 2: set Address to" w

    # -dr on system binary.
    rlRun "$OBJDUMP -dr /bin/true > D"
    rlAssertGrep "Disassembly of section .text:" d
    rlAssertGrep "_start" d
    rlAssertGrep "main" d

    # -R on system binary.
    rlRun "$OBJDUMP -R /bin/true > r"
    rlAssertGrep "abort" r

    # -T.
    rlRun "$OBJDUMP -T /bin/true > T"
    rlAssertGrep "abort" T

    rm -vf [DdrtTwR]
  rlPhaseEnd

  rlPhaseStartTest "Test readelf."
    # Readelf is probably most important, check more things.
    rlRun "$READELF --help"

    # Just run with -a.
    rlRun "$READELF -Wa virt"

    # Try -h.
    rlRun "$READELF -Wh virt > h"
    rlAssertGrep "ELF Header:" h
    rlAssertGrep "7f 45 4c 46" h
    rlAssertGrep "EXEC (Executable file)" h
    rlAssertGrep "Section header string table index:" h
    rlAssertGrep "ABI Version:" h

    # Try -l.
    rlRun "$READELF -Wl virt > l"
    rlAssertGrep "There are .* program headers, starting at offset" l
    rlAssertGrep "Section to Segment mapping:" l
    rlAssertGrep "[Requesting program interpreter: /lib*]" l

    # Try -S.
    rlRun "$READELF -WS virt > S"
    rlAssertGrep "There are .* section headers, starting at offset" S
    # I don't like rlAssertGrep.
    rlRun "grep -E '\[[0-9]*\] \.(got|ctors|text|plt|init|symtab|bss|strtab|eh_*)' S"

    # Try -s.
    rlRun "$READELF -Ws virt > s"
    rlAssertGrep "Symbol table '.symtab' contains .* entries:" s
    rlRun "grep -E '[0-9]*\: [0-9a-f]*[\ \t]*[0-9]* (FUNC|OBJECT|NOTYPE)[\ \t]*(WEAK|GLOBAL)[\ \t]*(DEFAULT|HIDDEN)[\ \t]*([0-9]*|UND|ABS).*' s"

    # Try -n.
    rlRun "$READELF -Wn virt > n"
    rlRun "grep -qE '[Nn]otes.*at.*offset .* with length .*:|Displaying notes found in: .note.ABI-tag' n"

    # Try -r.
    rlRun "$READELF -Wr virt > r"
    rlRun "grep -E 'Relocation section .\.rela?.(dyn|plt). at offset 0x[0-9a-f]+ contains [0-9]+ entries\:' r"

    # Try -d.
    rlRun "$READELF -Wd virt > d"
    rlAssertGrep "Dynamic section at offset .* contains .* entries:" d
    rlRun "grep -E '0x[0-9a-f]+ \((JMPREL|STRSZ|INIT|NEEDED|VERSYM|RELA|DEBUG|SYMENT|GNU_HASH|STRTAB)\)[\ \t]*(Shared|0x|[0-9]*)' d"

    # Try -I.
    rlRun "$READELF -I virt > I"
    # PPC64 produces no output (?).
    if [ "$(rlGetPrimaryArch)" != "ppc64" ] && [ "$(rlGetPrimaryArch)" != "ppc64le" ]; then
        rlAssertGrep "Histogram for .* bucket list length (total of .* buckets):" I
    fi

    # Try hex dump.
    rlRun "$READELF -x .strtab virt > x"
    rlAssertGrep "Hex dump of section '.strtab':" x

    # Dump .debug_info.
    rlRun "$READELF -wi virt > w"
    rlAssertGrep "Compilation Unit @ offset .*:" w
    rlAssertGrep "DW_AT_producer" w
    rlAssertGrep "DW_AT_comp_dir" w
    rlAssertGrep "DW_TAG_structure_type" w
    rlRun "grep -E '<[0-9]+><[0-9a-f]+>\: Abbrev Number\: [0-9]+ \(DW_TAG_.*\)' w"
    rlRun "grep -E '<[0-9]+>[\ \t]+DW_AT_.*\:' w"

    # Version info.
    rlRun "$READELF -V virt > V"
    rlAssertGrep "Version symbols section '.gnu.version' contains .* entries:" V
    rlRun "grep -E '(0x)?[0-9a-f]*\: Version\:.*File\:.*Cnt\: [0-9]+' V"

    # Try -h on /bin/true.
    rlRun "$READELF -Wh /bin/true > H"
    rlAssertGrep "ELF Header:" H
    rlAssertGrep "7f 45 4c 46" H
    rlAssertGrep "DYN (Position-Independent Executable file)" H
    rlAssertGrep "Section header string table index:" H
    rlAssertGrep "ABI Version:" H

    # Try -l on /bin/true.
    rlRun "$READELF -Wl /bin/true > L"
    rlAssertGrep "There are .* program headers, starting at offset" L
    rlAssertGrep "Section to Segment mapping:" L
    rlAssertGrep "[Requesting program interpreter: /lib*]" L

    # Try -S on /bin/true.
    rlRun "$READELF -WS /bin/true > F"
    rlAssertGrep "There are .* section headers, starting at offset" F
    rlRun "grep -E '\[[0-9]*\] \.(got|ctors|text|plt|init|symtab|bss|strtab|eh_*)' F"

    # Try -r on /bin/true.
    rlRun "$READELF -Wr /bin/true > c"
    rlRun "grep -E 'Relocation section .\.rela?.(dyn|plt). at offset 0x[0-9a-f]+ contains [0-9]+ entries\:' c"

    rm -vf [HIwhnSLslcrxVdF]
  rlPhaseEnd

  rlPhaseStartTest "Test size."
    rlRun "$SIZE --help"

    rlRun "$SIZE -dB virt > s"
    rlAssertGrep "text.*data.*bss.*dec.*hex.*filename" s

    rlRun "$SIZE -dB /bin/ed > S"
    rlAssertGrep "text.*data.*bss.*dec.*hex.*filename" S

    rm -vf [Ss]
  rlPhaseEnd

  rlPhaseStartTest "Test strings."
    rlRun "$STRINGS --help"

    # Try on our binary.
    rlRun "$STRINGS virt > s"
    rlAssertGrep "__gmon_start__" s
    rlAssertGrep "libc.so.6" s
    rlAssertGrep "abort" s
    rlAssertGrep "libm.so.6" s

    # Try on system binary.
    rlRun "$STRINGS /bin/echo > S"
    rlAssertGrep "abort" S
    rlAssertGrep "echo" S
    rlAssertGrep "POSIXLY_CORRECT" S
    rlAssertGrep "libc.so.6" S

    rm -vf [Ss]
  rlPhaseEnd

  rlPhaseStartCleanup
    rlRun "popd"
    rlRun "rm -r $TmpDir" 0 "Removing tmp directory"
  rlPhaseEnd
rlJournalPrintText
rlJournalEnd
