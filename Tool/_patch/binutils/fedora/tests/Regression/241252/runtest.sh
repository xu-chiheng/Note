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
        rlShowRunningKernel

        rlRun "TmpDir=\$(mktemp -d)" 0 "Creating tmp directory"
        cp x.i y.i $TmpDir
        rlRun "pushd $TmpDir"

        rlRun "gcc -c -O2 -fpic -o x.o x.i -g" 0 "Compile test case 'x'"
        rlRun "gcc -c -O2 -fpic -o y.o y.i -g" 0 "Compile test case 'y'"
        rlRun "gcc -Wl,--unique -o x [xy].o" 0 "Link 'x' and 'y'"

        # Note: debug_ranges replaced by debug_rnglist (since DWARF 5 in Fedora 34)
        rlLogInfo 'x.o + y.o:'
        rlLogInfo "$( readelf -WS [xy].o | grep debug_rnglist | grep PROGBITS )"
        rlLogInfo 'x:'
        rlLogInfo "$( readelf -WS x | grep debug_rnglist )"
    rlPhaseEnd

    rlPhaseStartTest Testing
        if [ $( readelf -WS [xy].o | grep debug_rnglist | grep PROGBITS | wc -l ) -eq 2 ] \
            && [ $( readelf -WS x | grep debug_rnglist | wc -l ) -eq 1 ]; then
            rlPass "Debug ranges sections were merged"
        else
            rlFail "Debug ranges sections were not merged"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup Cleanup
        rlRun "popd"
        rlRun "rm -r $TmpDir $rlRun_LOG" 0 "Removing tmp directory"
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
