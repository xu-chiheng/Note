#!/bin/bash
# vim: dict+=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   runtest.sh of /tools/binutils/Sanity/rebuild-coreutils
#   Description: Rebuild coreutils
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

PACKAGES="binutils"
REQUIRES="${REQUIRES:-coreutils}"
TEST_USER="${TEST_USER:-jouda}"

rlJournalStart
    rlPhaseStartSetup
        rlAssertRpm --all

        rlRun "TmpDir=\$(mktemp -d)" 0 "Creating tmp directory"
        rlRun "pushd $TmpDir"

        rlRun 'dnf -y update coreutils' 0-255

        rlRun "koji download-build --arch=src $(rpm -q coreutils)"
        rlRun "SRPM=`find . -name 'coreutils-*.src.rpm'`"
        rlRun "dnf builddep -y $SRPM"

        rlRun "userdel -r $TEST_USER" 0,6
        rlRun "useradd -m -d /home/$TEST_USER $TEST_USER"
        rlRun "cp $SRPM /home/$TEST_USER"
        rlRun "su - $TEST_USER -c 'rpm -Uvh $SRPM'"
    rlPhaseEnd

    rlPhaseStartTest
        rlRun "su - $TEST_USER -c 'rpmbuild -bc --clean \$(rpm --eval=%_specdir)/coreutils.spec'"
    rlPhaseEnd

    rlPhaseStartCleanup
        rlRun "userdel -r $TEST_USER"
        rlRun "popd"
        rlRun "rm -r $TmpDir" 0 "Removing tmp directory"
    rlPhaseEnd
rlJournalPrintText
rlJournalEnd
