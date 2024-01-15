#!/bin/bash
# vim: dict+=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   runtest.sh of /CoreOS/binutils/Regression/bz1465318-FJ7-4-Bug-REG-The-results-of-gprof-command
#   Description: Test for BZ#1465318 ([FJ7.4 Bug] [REG] The results of gprof command)
#   Author: Milos Prchlik <mprchlik@redhat.com>
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   Copyright (c) 2017 Red Hat, Inc.
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

LD="${LD:-$(which ld)}"
PACKAGE=$(rpm --qf '%{name}\n' -qf $(which $LD) | head -1)
PACKAGES=${PACKAGE}
REQUIRES="${REQUIRES:-gcc}"

rlJournalStart
    rlPhaseStartSetup
        rlLogInfo "PACKAGES=$PACKAGES"
        rlLogInfo "REQUIRES=$REQUIRES"
        rlLogInfo "COLLECTIONS=$COLLECTIONS"
        rlLogInfo "LD=$LD"
        rlLogInfo "$(type gcc)"
        rlAssertRpm --all

        rlRun "TmpDir=\$(mktemp -d)" 0 "Creating tmp directory"
        rlRun "cp gprof.file.c $TmpDir/"
        rlRun "pushd $TmpDir"
        rlRun "gcc -pg -g gprof.file.c -o gprof.file"
        rlRun "./gprof.file"
        rlAssertExists "gmon.out"
    rlPhaseEnd

    rlPhaseStartTest
        rlRun "gprof -A gprof.file > option-large_A"
        rlRun "gprof -C gprof.file > option-large_C"
        rlRun "gprof -l gprof.file > option-l"

        rlLogInfo "$(cat option-large_A)"
        rlLogInfo "$(cat option-large_C)"
        rlLogInfo "$(cat option-l)"

        rlRun "grep -E '##### -> +void fun3\(\)\{\}' option-large_A"
        rlRun "grep -E '1 -> +void fun1\(\)\{int i=0;\}' option-large_A"

        rlRun "grep -E 'gprof.file.c:2: \(fun1:0x[0-9a-z]+\) 1 executions' option-large_C"

        rlRun "grep -E '0.00 +0.00 +0.00 +1 +0.00 +0.00 +fun1 \(gprof.file.c:2 @ [0-9a-z]+\)' option-l"
        rlRun "grep -E '\[1\] +0.0 +0.00 +0.00 +1 +fun1 \(gprof.file.c:2 @ [0-9a-z]+\) \[1\]' option-l"
        rlRun "grep -E '\[1\] fun1 \(gprof.file.c:2 @ [0-9a-z]+\) \[2\] fun2 \(gprof.file.c:1 @ [0-9a-z]+\)' option-l"
    rlPhaseEnd

    rlPhaseStartCleanup
        rlRun "popd"
        rlRun "rm -r $TmpDir" 0 "Removing tmp directory"
    rlPhaseEnd
rlJournalPrintText
rlJournalEnd
