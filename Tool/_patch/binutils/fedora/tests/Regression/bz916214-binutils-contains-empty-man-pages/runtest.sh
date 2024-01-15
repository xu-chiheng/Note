#!/bin/bash
# vim: dict=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   runtest.sh of /tools/binutils/Regression/bz916214-binutils-contains-empty-man-pages
#   Description: Test for BZ#916214 (binutils contains empty man pages)
#   Author: Miroslav Franc <mfranc@redhat.com>
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   Copyright (c) 2013 Red Hat, Inc. All rights reserved.
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


rlJournalStart
    rlPhaseStartSetup
        rlAssertRpm binutils
        rlRun "TmpDir=\$(mktemp -d)" 0 "Creating tmp directory"
        rlRun "pushd $TmpDir"
    rlPhaseEnd

    rlPhaseStartTest
	rpm -qd binutils | grep 'man' | while read -r m
        do
	    rlLog "$m"
            man "$m" | col -b > man.txt 
	    rlRun "[[ $(wc -c <man.txt) -ge 2000 ]]"
	    rlRun "[[ $(wc -l <man.txt) -ge 50 ]]"
            rlAssertGrep NAME man.txt
            rlAssertGrep SYNOPSIS man.txt
            rlAssertGrep DESCRIPTION man.txt
            rlAssertGrep OPTIONS man.txt
            rlAssertGrep COPYRIGHT man.txt
            rlAssertGrep 'Free Software Foundation' man.txt
            rlAssertGrep binutils man.txt
	    md5sum man.txt >> sums.log
        done
	rlLog "Do we have enough man pages?"
        rlRun "[[ $(wc -l <sums.log) -ge 14 ]]"
	rlLog "Are they all different?"
        rlRun "[[ $(sort sums.log | uniq | wc -l) -eq $(wc -l <sums.log) ]]"
	unset i
    rlPhaseEnd

    rlPhaseStartCleanup
        rlRun "popd"
        rlRun "rm -r $TmpDir" 0 "Removing tmp directory"
    rlPhaseEnd
rlJournalPrintText
rlJournalEnd
