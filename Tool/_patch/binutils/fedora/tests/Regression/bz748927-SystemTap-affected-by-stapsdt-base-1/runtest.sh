#!/bin/bash
# vim: dict=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   runtest.sh of /tools/binutils/Regression/bz748927-SystemTap-affected-by-stapsdt-base-1
#   Description: Make sure there is .stapsdt.base field
#   Author: Michal Nowak <mnowak@redhat.com>
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   Copyright (c) 2011 Red Hat, Inc. All rights reserved.
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
        rlCheckRpm glibc
        rlRun "TmpDir=\$(mktemp -d)" 0 "Creating tmp directory"
        rlRun "pushd $TmpDir"
        rlRun "grep -q CONFIG_UTRACE /boot/config-$( uname -r )" 0,1 || rlLogWarning "Uprobes disabled"
    rlPhaseEnd

for ld in $( ls {/emul/ia32-linux,}/lib*/ld-2* 2> /dev/null); do
    rlPhaseStartTest "${ld} from $( rpmquery -f ${ld} )"
        filename="$( basename ${ld} ).readline"
        rlRun "readelf -S ${ld} > $filename" 0 "[$( basename ${ld} )] Write section headers of ${ld}"
        if ! [[ "$( rlGetArch )" == "ia64" && ! "${ld}" =~ "emul" ]]; then
            rlAssertGrep ".stapsdt.base " $filename || rlLogError "This may be problem for SystemTap"
        fi
        rlAssertNotGrep ".stapsdt.base.1" $filename || rlLogError "This may be problem for SystemTap"
    rlPhaseEnd
done

    rlPhaseStartCleanup
        rlRun "popd"
        rlRun "rm -r $TmpDir" 0 "Removing tmp directory"
    rlPhaseEnd
rlJournalPrintText
rlJournalEnd
