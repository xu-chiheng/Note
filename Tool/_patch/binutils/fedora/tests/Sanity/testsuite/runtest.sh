#!/bin/bash
# vim: dict+=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   runtest.sh of /tools/binutils/Sanity/testsuite
#
#   Description: The test rebuilds binutils.src.rpm and runs the suite.
#   The test is based on /tools/binutils/testsuite, but it had to be
#   rewritten.
#
#   Author: Michael Petlan <mpetlan@redhat.com>
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

LD="${LD:-$(which ld)}"
GCC="${GCC:-$(which gcc)}"

PACKAGE="${PACKAGE:-$(rpm --qf '%{name}\n' -qf $(which $LD) | head -1)}"
NVR="$(rpm -q --qf='%{NAME}-%{VERSION}-%{RELEASE}\n' $PACKAGE | head -1)"
GCC_PACKAGE="${GCC_PACKAGE:-$(rpm --qf '%{name}\n' -qf $(which $GCC) | head -1)}"

PACKAGES="${PACKAGES:-$PACKAGE}"
REQUIRES="${REQUIRES:-$GCC_PACKAGE}"

rlJournalStart
    rlPhaseStartSetup
        rlLogInfo "PACKAGES=$PACKAGES"
        rlLogInfo "REQUIRES=$REQUIRES"
        rlLogInfo "COLLECTIONS=$COLLECTIONS"
        rlLogInfo "PACKAGE=$PACKAGE"
        rlLogInfo "NVR=$NVR"
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

        # temp dir
        rlRun "TESTDIR=$PWD"

        rlRun "TmpDir=\$(mktemp -d)" 0 "Creating tmp directory"
        rlRun "pushd $TmpDir"
        rlRun "mkdir LOGS"
        rlRun "LOGDIR=$TmpDir/LOGS"

        # fetch'n'build the source
        rlRun "dnf download --disablerepo='*' --enablerepo=test-artifacts --source $NVR || cp /var/share/test-artifacts/$NVR.src.rpm ."
        rlRun "dnf builddep -y $NVR.src.rpm"
        rlRun "rpm -i $NVR.src.rpm"
        export SPECDIR=`rpm --eval=%_specdir`
        export BUILDDIR=`rpm --eval=%_builddir`
        export CURRENT_BUILD=${BUILDDIR}/binutils-$(rpmquery $PACKAGE --queryformat='%{VERSION}\n' | head -n 1)
        rlRun "rpmbuild -bc $SPECDIR/binutils.spec"
        rlRun "ARCH=$(arch)"

        rlRun "cp $CURRENT_BUILD/*/binutils/binutils.log $CURRENT_BUILD/*/binutils/binutils.sum $LOGDIR/"
        rlRun "cp $CURRENT_BUILD/*/ld/ld.log $CURRENT_BUILD/*/ld/ld.sum $LOGDIR/"
        rlRun "cp $CURRENT_BUILD/*/gas/testsuite/gas.log $CURRENT_BUILD/*/gas/testsuite/gas.sum $LOGDIR/"
    rlPhaseEnd

    if [ "$ARCH" = "x86_64" ]; then
        rlPhaseStartTest Regression-bz1614908
            rlLogInfo "Checking if bz#1614908 is reproducible"
            rlRun "gold_test_binary=$(find $CURRENT_BUILD -iname gnu_property_test -type f -executable)" 0 "Looking for binary from gold testsuite"
            rlAssertExists $gold_test_binary
            rlAssertEquals 'Just one .note.gnu.property section' "$(readelf --wide --sections $gold_test_binary | grep -c -F .note.gnu.property)" 1
            rlAssertEquals 'The .note.gnu.property section is aligned to 8' "$(readelf --wide --sections $gold_test_binary | awk '/\.note\.gnu\.property/ {print $NF}')" 8
            rlAssertEquals 'First NOTE segment is aligned to 8' "$(readelf --wide --segments $gold_test_binary | awk '/NOTE/ {print $NF; exit}')" '0x8'
        rlPhaseEnd
    fi

    for TOOL in binutils ld gas; do
        rlPhaseStartTest "$TOOL"
            rlLogInfo "$TOOL Summary"
            rlLogInfo "$(grep -A 50 '=== .* Summary ===' $LOGDIR/$TOOL.sum)"

            # Store list of failed test cases
            rlRun "grep '^FAIL: ' $LOGDIR/$TOOL.sum |& sort | tee $LOGDIR/$TOOL.failed" 0,1

            rlRun "grep '# of unexpected failures' $LOGDIR/$TOOL.sum" 0,1 "Checking number of unexpected failures"

            # Handle expected failures
            if [ "$?" = "0" ]; then
                expected_fails_file="" # here we define expected failures if needed
                if [ "$expected_fails_file" = "" ]; then
                    rlFail "No list of expected failures exists for this environment: release=$(cat /etc/redhat-release), arch=$ARCH, tool=$TOOL"
                    rlFail "Unexpected failures found"
                else
                    rlRun "diff $expected_fails_file $LOGDIR/$TOOL.failed" 0,1
                    if [ "$?" != "0" ]; then
                        rlFail "Unexpected failures found"
                    else
                        rlPass "No unexpected failures found"
                    fi
                fi
            else
                rlPass "No unexpected failures found"
            fi
        rlPhaseEnd
    done

    rlPhaseStartCleanup
        rlRun "tar czf $TmpDir/logs.tgz $LOGDIR/*.sum $LOGDIR/*.log"
        rlRun "tar czf $TmpDir/buildroot.tgz $CURRENT_BUILD/"
        rlFileSubmit logs.tar.gz
        rlFileSubmit buildroot.tgz
        rlRun "popd" # $TmpDir
        rlRun "rm -r $TmpDir" 0 "Removing tmp directory"
    rlPhaseEnd
rlJournalPrintText
rlJournalEnd
