#!/bin/bash
# vim: dict=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   runtest.sh of /tools/gdb/Sanity/debug-toolset-binary
#   Description: We debug a binary that is delivered via the Toolset.
#   Author: Marek Polacek <polacek@redhat.com>
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   Copyright (c) 2012 Red Hat, Inc. All rights reserved.
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

# We create an empty file `empty.S'.  The we run the as(1) to produce
# the `a.out' file and at the same time, we debug the as(1).
# Note that as(1) should come from the Developer Toolset (TM),
# but in fact, it doesn't have to.  It should not fail either way.

# Include Beaker environment
. /usr/share/beakerlib/beakerlib.sh || exit 1

CMD="gdb"
BIN="$(which $CMD)"
export PACKAGE="${PACKAGE:-$(rpm -qf --qf='%{name}\n' $BIN)}"

PACKAGES="coreutils binutils binutils-debuginfo glibc glibc-debuginfo gcc gcc-debuginfo zlib zlib-debuginfo"

rlJournalStart
  rlPhaseStartSetup
    rlShowRunningKernel
    rlAssertRpm $PACKAGE
    for pkg in $PACKAGES; do
       rlAssertRpm $pkg
    done
    rlRun "TmpDir=\$(mktemp -d)"
    rlRun "cp cmds $TmpDir"
    rlRun "pushd $TmpDir"
    rlRun ": >empty.s"
  rlPhaseEnd

  rlPhaseStartTest
    rlRun "gdb -nx -q -batch -x cmds --args as empty.s"
    rlRun "nm >symbs"
    if [ -s symbs ]; then
      rlFail "nm should't output any symbols"
      rlRun "cat symbs"
    fi
  rlPhaseEnd

  rlPhaseStartCleanup
    rlRun "popd"
    rlRun "rm -r $TmpDir"
  rlPhaseEnd
rlJournalPrintText
rlJournalEnd
