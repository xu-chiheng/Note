#!/bin/bash
# vim: dict+=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   runtest.sh of /tools/binutils/Regression/bz1172766-ppc64-segv-in-libbfd
#   Description: Test for BZ#1172766 (ppc64 segv in libbfd)
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
REQUIRES="${REQUIRES:-kernel-debuginfo}"

__have_kernel_debuginfo () {
    local RELEASE ARCH TEMPDIR
    rlRun "RELEASE=$(uname -r)"
    rlRun "ARCH=$(uname -m)"
    if ! rpm -q kernel-debuginfo-$RELEASE &>/dev/null; then
        rlLogInfo 'kernel-debuginfo not present, trying to install it'
        rlRun "TEMPDIR=$(mktemp -d -p $HOME)" # $HOME to avoid "small" tmpfs
        rlRun "pushd '$TEMPDIR'"
        rlRun "koji download-build -q --debuginfo kernel-$RELEASE --arch $ARCH"
        rlRun "dnf -y install ./kernel-debuginfo-*.rpm"
        rlRun 'popd'
        rlRun "rm -rf '$TEMPDIR'"
    fi
    rlAssertRpm kernel-debuginfo-$RELEASE
}

rlJournalStart
    rlPhaseStartSetup
        rlLogInfo "PACKAGES=$PACKAGES"
        rlLogInfo "REQUIRES=$REQUIRES"
        rlLogInfo "COLLECTIONS=$COLLECTIONS"
        rlLogInfo "KERNEL=$(uname -a)"

        __have_kernel_debuginfo

        rlAssertRpm --all

        rlRun "TmpDir=\$(mktemp -d)" 0 "Creating tmp directory"
        rlRun "pushd $TmpDir"

        rlRun "KERNEL_RELEASE=$(uname -r)"
        rlRun "KMOD=/usr/lib/modules/$KERNEL_RELEASE/kernel/fs/nfsd/nfsd.ko"
        rlRun "KMOD_XZ=$KMOD.xz"
        rlRun "KMOD_DEBUG=/usr/lib/debug/$KMOD.debug"
        rlAssertExists "$KMOD_DEBUG"
        rlAssertExists "$KMOD_XZ"
        [[ -e "$KMOD" ]] || rlRun "unxz -k $KMOD_XZ"
        rlAssertExists "$KMOD"
    rlPhaseEnd

    rlPhaseStartTest
        rlRun "eu-unstrip $KMOD $KMOD_DEBUG --output=$TmpDir/unstripped.ko"
        rlRun "objdump -drS $TmpDir/unstripped.ko &> /dev/null"
    rlPhaseEnd

    rlPhaseStartCleanup
        rlRun "popd"
        rlRun "rm -r $TmpDir" 0 "Removing tmp directory"
    rlPhaseEnd
rlJournalPrintText
rlJournalEnd
