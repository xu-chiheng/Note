#!/bin/bash
# vim: dict+=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   runtest.sh of /tools/binutils/Regression/bz1624776-binutils-ld-removes-some-R-X86-64-JUMP-SLOT
#   Description: Test for BZ#1624776 (binutils ld removes some R_X86_64_JUMP_SLOT)
#   Author: Edjunior Machado <emachado@redhat.com>
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   Copyright (c) 2018 Red Hat, Inc.
#
#   This program is free software: you can redistribute it and/or
#   modify it under the terms of the GNU General Public License as
#   published by the Free Software Foundation, either version 2 of
#   the License, or (at your option) any later version.
#
#   This program is distributed in the hope that it will be
#   useful, but WITHOUT ANY WARRANTY; without even the implied
#   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#   PURPOSE.  See the GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program. If not, see http://www.gnu.org/licenses/.
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Include Beaker environment
. /usr/share/beakerlib/beakerlib.sh || exit 1

PACKAGE="$(rpm -qf $(which ld))"

rlJournalStart
    rlPhaseStartSetup
        rlAssertRpm $PACKAGE
        rlRun "TmpDir=\$(mktemp -d)" 0 "Creating tmp directory"
        rlRun "cp reloc.s $TmpDir"
        rlRun "pushd $TmpDir"
    rlPhaseEnd

    rlPhaseStartTest
        rlRun "as -o reloc.o reloc.s"
        rlAssertExists "reloc.o"
        rlRun "ld -o reloc.so -shared reloc.o"
        rlAssertExists "reloc.so"
        # Conserve the non-zero return value through the pipe
        set -o pipefail
        rlRun "readelf -rW reloc.so |& tee readelf.out" 0 "Checking out reloc.so relocation section"
        rlRun "sed -n '/.rela.dyn/,/^$/p' readelf.out | grep R_X86_64_GLOB_DAT" 0 "Relocation section .rela.dyn should contain R_X86_64_GLOB_DAT entry"
        rlRun "sed -n '/.rela.plt/,/^$/p' readelf.out | grep R_X86_64_JUMP_SLOT" 0 "Relocation section .rela.plt should contain R_X86_64_JUMP_SLOT entry"
        rlFileSubmit readelf.out
    rlPhaseEnd

    rlPhaseStartCleanup
        rlRun "popd"
        rlRun "rm -r $TmpDir" 0 "Removing tmp directory"
    rlPhaseEnd
rlJournalPrintText
rlJournalEnd
