#!/bin/bash
# vim: dict=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
#
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
# Author: Michal Nowak <mnowak@redhat.com>
#
# Include rhts environment
. /usr/share/beakerlib/beakerlib.sh || exit 1

PACKAGE="binutils"

# Choose the compiler.
GCC=${GCC:-gcc}

rlJournalStart
    rlPhaseStartSetup
        rlAssertRpm $PACKAGE
	rlShowPackageVersion $PACKAGE
	rlShowRunningKernel

        rlRun "TmpDir=\$(mktemp -d)" 0 "Creating tmp directory"
	cp foo.c bar.c $TmpDir
        rlRun "pushd $TmpDir"
    rlPhaseEnd

    rlPhaseStartTest "gcc=$GCC Testing"
        rlRun "$GCC -fPIC -c -o foo.o foo.c" 0 "Compile foo.c => foo.o"
        rlRun "$GCC -fPIC -c -o bar.o bar.c" 0 "Compile bar.c => bar.o"
        rlRun "ld -shared -o foobar.so foo.o bar.o" 0 "Link foo.o & bar.o => foobar.so"
        rlAssertExists foobar.so
        rm foobar.so foo.o bar.o
    rlPhaseEnd

    rlPhaseStartCleanup Cleanup
        rlRun "popd"
        rlRun "rm -r $TmpDir" 0 "Removing tmp directory"
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
