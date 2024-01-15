#!/bin/bash
# vim: dict+=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   runtest.sh of /tools/binutils/Regression/bz1693661-rhel8-gold-does-not-resolve-the-address-of-main
#   Description: Test for BZ#1693661 (rhel8 gold does not resolve the address of main())
#   Author: Edjunior Machado <emachado@redhat.com>
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   Copyright (c) 2019 Red Hat, Inc.
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

LD="${LD:-$(which ld.gold)}"
GCC="${GCC:-$(which gcc)}"

PACKAGE="${PACKAGE:-$(rpm --qf '%{name}\n' -qf $(which $LD) | head -1)}"
GCC_PACKAGE="${GCC_PACKAGE:-$(rpm --qf '%{name}\n' -qf $(which $GCC) | head -1)}"

PACKAGES="${PACKAGES:-$PACKAGE}"
REQUIRES="${REQUIRES:-$GCC_PACKAGE}"

rlJournalStart
    rlPhaseStartSetup
        rlLogInfo "PACKAGES=$PACKAGES"
        rlLogInfo "REQUIRES=$REQUIRES"
        rlLogInfo "COLLECTIONS=$COLLECTIONS"
        rlLogInfo "PACKAGE=$PACKAGE"
        rlLogInfo "LD=$LD"
        rlLogInfo "GCC=$GCC"

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
        rlRun "cp main.c foo.c $TmpDir/"
        rlRun "pushd $TmpDir"
    rlPhaseEnd

    rlPhaseStartTest
        rlRun "gcc -o main.o -fPIC -c main.c"
        rlRun "gcc -shared -o libmain.so main.o"
        rlRun "gcc -o foo.o -c foo.c"

        rlLogInfo "Linking with gold..."
        rlRun "gcc -fuse-ld=gold -o gold.out -lmain -L$PWD -Wl,-v,-rpath=$PWD foo.o"
        rlAssertExists "gold.out"
        rlRun "./gold.out" # On bz#1693661, it segfaults

        rlLogInfo "Linking with bfd..."
        rlRun "gcc -fuse-ld=bfd -o bfd.out -lmain -L$PWD -Wl,-v,-rpath=$PWD foo.o"
        rlAssertExists "bfd.out"
        rlRun "./bfd.out"
    rlPhaseEnd

    rlPhaseStartCleanup
        rlRun "popd"
        rlRun "rm -r $TmpDir" 0 "Removing tmp directory"
    rlPhaseEnd
rlJournalPrintText
rlJournalEnd
