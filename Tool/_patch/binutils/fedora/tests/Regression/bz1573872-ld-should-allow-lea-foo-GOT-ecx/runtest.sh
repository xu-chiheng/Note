#!/bin/bash
# vim: dict+=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   runtest.sh of /tools/binutils/Regression/bz1573872-ld-should-allow-lea-foo-GOT-ecx
#   Description: Test for BZ#1573872 (ld should allow "lea foo@GOT, %ecx")
#   Author: Milos Prchlik <mprchlik@redhat.com>
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

AS="${AS:-$(which as)}"
PACKAGE=$(rpm --qf '%{name}\n' -qf $(which $AS) | head -1)
PACKAGES="${PACKAGES:-$PACKAGE}"
REQUIRES="${REQUIRES:-}"

rlJournalStart
    rlPhaseStartSetup
        rlLogInfo "PACKAGES=$PACKAGES"
        rlLogInfo "REQUIRES=$REQUIRES"
        rlLogInfo "COLLECTIONS=$COLLECTIONS"
        rlLogInfo "AS=$AS"
        rlLogInfo "SKIP_COLLECTION_METAPACKAGE_CHECK=$SKIP_COLLECTION_METAPACKAGE_CHECK"

        # We optionally need to skip checking for the presence of the metapackage
        # because that would pull in all the dependent toolset subrpms.  We do not
        # always want that, especially in CI.
        _COLLECTIONS="$COLLECTIONS"
        if ! test -z $SKIP_COLLECTION_METAPACKAGE_CHECK; then
            for c in $SKIP_COLLECTION_METAPACKAGE_CHECK; do
                rlLogInfo "ignoring metapackage check for collection $c"
                export COLLECTIONS=$(shopt -s extglob && echo ${COLLECTIONS//$c/})
            done
        fi

        rlLogInfo "(without skipped) COLLECTIONS=$COLLECTIONS"

        rlAssertRpm --all

        export COLLECTIONS="$_COLLECTIONS"

        rlRun "TmpDir=\$(mktemp -d)" 0 "Creating tmp directory"
        rlRun "cp reproducer.S $TmpDir/"
        rlRun "pushd $TmpDir"
    rlPhaseEnd

    rlPhaseStartTest
        rlRun "gcc -B./ -m32 -c -o reproducer.o reproducer.S"
        rlRun "ld -melf_i386 -shared -o libx.so reproducer.o"
    rlPhaseEnd

    rlPhaseStartCleanup
        rlRun "popd"
        rlRun "rm -r $TmpDir" 0 "Removing tmp directory"
    rlPhaseEnd
rlJournalPrintText
rlJournalEnd
