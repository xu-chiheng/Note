#!/bin/bash
# vim: dict=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   runtest.sh of /tools/binutils/Regression/RELRO-protection-effective
#   Description: bz1174826
#   Author: Martin Cermak <mcermak@redhat.com>
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   Copyright (c) 2014 Red Hat, Inc.
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

PACKAGE="binutils"

rlJournalStart
    rlPhaseStartSetup
        rlAssertRpm $PACKAGE
        touch /tmp/disable-qe-abrt
        rlRun "TMPD=\$(mktemp -d)"
        rlRun "pushd $TMPD"
        cat > relro.c <<-EOF
#include <stdio.h>

void *const foo = &stdout;

int main (void)
{
  *(void **) &foo = &stderr;
  return 0;
}
EOF
        rlRun "gcc -pie -fPIE -g  -Wl,-z,relro -o relro relro.c"
        rlRun "gcc -pie -fPIE -g  -Wl,-z,norelro -o no-relro relro.c"
    rlPhaseEnd

    rlPhaseStartTest
        rlRun "./relro" 139
        rlRun "./no-relro"
    rlPhaseEnd

    rlPhaseStartCleanup
        rlRun "popd"
        rlRun "rm -r $TMPD"
        rm -f /tmp/disable-qe-abrt
    rlPhaseEnd
rlJournalPrintText
rlJournalEnd
