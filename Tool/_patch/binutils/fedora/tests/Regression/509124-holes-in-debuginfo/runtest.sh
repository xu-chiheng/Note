#!/bin/bash
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

rlJournalStart
    rlPhaseStartSetup Setup
        rlAssertRpm $PACKAGE
	rlShowPackageVersion $PACKAGE
	rlShowRunningKernel

        rlRun "TmpDir=\$(mktemp -d)" 0 "Creating tmp directory"
	cp ascend.C test.c $TmpDir
        rlRun "pushd $TmpDir"
    rlPhaseEnd

    for gcc in $( ls /usr/bin/gcc{,44} 2> /dev/null ); do
      for opt in s $( seq 0 3 ); do
        rlPhaseStartTest "ascend.C: gcc=$gcc opt=$opt"
            rlRun "$gcc -O${opt} ascend.C -c -g"
            rlAssertExists "ascend.o"
            # kinda weird running readelf on .o file, but...
            rlRun "readelf -a -w -W ./ascend.o > /dev/less 2> readelf.errout.g++" 0 "[gcc] Generating readelf output"
            rlLog "$( cat readelf.errout.g++ )"
	    rlAssertNotGrep "readelf" readelf.errout.g++
            rm -f ./ascend.o
        rlPhaseEnd
      done
    done

    for gcc in $( ls /usr/bin/gcc{,44} 2> /dev/null ); do
      for opt in s $( seq 0 3 ); do
        rlPhaseStartTest "test.c: gcc=$gcc opt=$opt"
            rlRun "$gcc -O${opt} test.c -c -g"
            rlAssertExists "test.o"
            # kinda weird running readelf on .o file, but...
            rlRun "readelf -a -w -W ./test.o > /dev/less 2> readelf.errout.g++" 0 "[gcc] Generating readelf output"
            rlLog "$( cat readelf.errout.g++ )"
	    rlAssertNotGrep "readelf" readelf.errout.g++
            rm -f ./test.o
        rlPhaseEnd
      done
    done

    rlPhaseStartCleanup Cleanup
        rlRun "popd"
        rlRun "rm -r $TmpDir" 0 "Removing tmp directory"
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
