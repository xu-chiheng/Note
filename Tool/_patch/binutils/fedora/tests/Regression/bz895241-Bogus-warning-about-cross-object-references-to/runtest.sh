#!/bin/bash
# vim: dict+=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   runtest.sh of /tools/binutils/Regression/bz895241-Bogus-warning-about-cross-object-references-to
#   Description: Test for BZ#895241 (Bogus warning about cross object references to)
#   Author: Milos Prchlik <mprchlik@redhat.com>
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   Copyright (c) 2015 Red Hat, Inc.
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

PACKAGES="${PACKAGES:-binutils}"
REQUIRES="${REQUIRES:-gcc}"

ALTERNATIVES_ROOT="${ALTERNATIVES_ROOT:-}"

rlJournalStart
    rlPhaseStartSetup
        rlLogInfo "PACKAGES=$PACKAGES"
        rlLogInfo "REQUIRES=$REQUIRES"
        rlLogInfo "COLLECTIONS=$COLLECTIONS"
        rlAssertRpm --all

        rlRun "TmpDir=\$(mktemp -d)" 0 "Creating tmp directory"
        rlRun "cp t.c u.c v.c $TmpDir/"
        rlRun "pushd $TmpDir"

        rlRun "alternatives --altdir $ALTERNATIVES_ROOT/etc/alternatives/ --admindir $ALTERNATIVES_ROOT/var/lib/alternatives/ --display ld"
        rlRun "alternatives --altdir $ALTERNATIVES_ROOT/etc/alternatives/ --admindir $ALTERNATIVES_ROOT/var/lib/alternatives/ --set ld $ALTERNATIVES_ROOT/usr/bin/ld.gold"
        rlRun "alternatives --altdir $ALTERNATIVES_ROOT/etc/alternatives/ --admindir $ALTERNATIVES_ROOT/var/lib/alternatives/ --display ld"
    rlPhaseEnd

    rlPhaseStartTest
        rlRun "gcc v.c -fPIC -shared -olibv.so"
        rlRun "gcc u.c -fPIC -shared -olibu.so"
        rlRun "gcc t.c -D_GNU_SOURCE -L. -lu -lv -ldl -Wl,-rpath,`pwd` &> out"
        rlLogInfo "$(cat out)"
        rlAssertNotGrep "warning: hidden symbol .* is referenced" out
        rlRun "./a.out"
    rlPhaseEnd

    rlPhaseStartCleanup
        rlRun "alternatives --altdir $ALTERNATIVES_ROOT/etc/alternatives/ --admindir $ALTERNATIVES_ROOT/var/lib/alternatives/ --auto ld"
        rlRun "alternatives --altdir $ALTERNATIVES_ROOT/etc/alternatives/ --admindir $ALTERNATIVES_ROOT/var/lib/alternatives/ --display ld"
        rlRun "popd"
        rlRun "rm -r $TmpDir" 0 "Removing tmp directory"
    rlPhaseEnd
rlJournalPrintText
rlJournalEnd
