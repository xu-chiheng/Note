#!/bin/bash
# vim: dict+=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   runtest.sh of /tools/binutils/Regression/bz1117458-ld-from-devtoolset-copies-SONAME-to-DT-NEEDED
#   Description: Test for BZ#1117458 (ld from devtoolset copies SONAME to DT_NEEDED)
#   Author: Milos Prchlik <mprchlik@redhat.com>
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   Copyright (c) 2014 Red Hat, Inc.
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

PACKAGE="binutils"

rlJournalStart
    rlPhaseStartSetup
        rlAssertRpm $PACKAGE

        rlRun "TmpDir=\$(mktemp -d)" 0 "Creating tmp directory"
        rlRun "cp user.c libfoo.c $TmpDir/" 
        rlRun "pushd $TmpDir"
    rlPhaseEnd

    rlPhaseStartTest
        rlRun "gcc -fPIC -g -c libfoo.c"
        rlAssertExists "libfoo.o"
        rlRun "gcc -shared -Wl,-soname, -o libfoo.so -lc libfoo.o 2>&1 | tee out" 0
        rlAssertExists "libfoo.so"
        rlLogInfo "gcc output:"
        rlLogInfo "$(cat out)"
        rlAssertGrep "SONAME must not be empty string; ignored" out
        rlRun "objdump -p libfoo.so | grep SONAME | awk '{print \$2}' > soname"
        if [ "`stat -c '%s' soname`" != "0" ]; then
            rlLogInfo "SONAME='$(cat soname)'"
            rlFail "Detected SONAME is empty"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup
        rlRun "popd" # $TmpDir
        rlRun "rm -r $TmpDir" 0 "Removing tmp directory"
    rlPhaseEnd
rlJournalPrintText
rlJournalEnd
