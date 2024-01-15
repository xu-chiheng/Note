#!/bin/bash
# vim: dict=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   Copyright (c) 2009 Red Hat, Inc. All rights reserved.
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

# Include rhts environment
. /usr/share/beakerlib/beakerlib.sh || exit 1

PACKAGE="binutils"

rlJournalStart
    rlPhaseStartSetup Setup
        rlAssertRpm $PACKAGE
        rlShowPackageVersion $PACKAGE
        rlShowRunningKernel
        rlRun "TmpDir=\$(mktemp -d)" 0 "Creating tmp directory"
        rlRun "pushd $TmpDir"
	rlRun "echo -e \"asdjkhsd\nsdsdsdssd\n\nsdsd\n\" > tstfile" 0 "Generating test file tstfile"
    rlPhaseEnd

    rlPhaseStartTest TestingOne
	rlRun "strings -0 tstfile > errorfile 2>&1 &"
	rlRun "sleep 5"
	rlRun "jobs"
	rlRun "kill -9 %1" 1 "strings in the loop"
	rlAssertGrep "minim" errorfile
    rlPhaseEnd

    rlPhaseStartTest TestingTwo
	rlRun "strings -n 0xA tstfile" 0 "echo \"PASS: tstfile processed.\""
    rlPhaseEnd

    rlPhaseStartCleanup Cleanup
        rlBundleLogs "binutils-outputs" errorfile tstfile
        rlRun "popd"
        rlRun "rm -r $TmpDir $rlRun_LOG" 0 "Removing tmp directory"
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
