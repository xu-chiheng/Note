#!/bin/bash
# vim: dict+=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   runtest.sh of /tools/gdb/Sanity/gdb-testsuite-sanity
#   Description: gdb testing by upstream testsuite
#   Author: Michal Kolar <mkolar@redhat.com>
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   Copyright (c) 2021 Red Hat, Inc.
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

BUILD_USER=${BUILD_USER:-gdbbld}
export PACKAGE="${PACKAGE:-$(rpm -qf --qf='%{name}\n' `which gdb`)}"
RUNTESTFLAGS=${RUNTESTFLAGS:-GDB=`rpm -ql $PACKAGE | grep -E 'bin/gdb$'`}
TESTS_COUNT_MIN=${TESTS_COUNT_MIN:-4000}
REQUIRES="$PACKAGE rpm-build dejagnu make gcc glibc"
if rlIsFedora; then
  REQUIRES="$REQUIRES dnf-utils"
else
  REQUIRES="$REQUIRES yum-utils"
fi

rlJournalStart
  rlPhaseStartSetup
    rlShowRunningKernel
    rlAssertRpm --all
    rlRun "TmpDir=\$(mktemp -d)"
    rlRun "cp -r ./ref $TmpDir"
    rlRun "pushd $TmpDir"
    rlFetchSrcForInstalled $PACKAGE
    rlRun "useradd -M -N $BUILD_USER" 0,9
    [ $? -eq 0 ] && rlRun "del=yes"
    rlRun "chown -R $BUILD_USER:users $TmpDir"
    rlRun "cp /proc/sys/kernel/core_pattern $TmpDir/core_pattern.bckp"
    rlRun "echo 'core.%p' >/proc/sys/kernel/core_pattern"
    rlRun "ulimit -c unlimited"
  rlPhaseEnd

  rlPhaseStartSetup "build gdb"
    rlRun "su -c 'rpm -D \"_topdir $TmpDir\" -U *.src.rpm &>rpm.log' $BUILD_USER"
    rlRun "rlFileSubmit $TmpDir/rpm.log rpm.log"
    rlRun "su -c 'rpmbuild -D \"_topdir $TmpDir\" -bs --with testsuite $TmpDir/SPECS/*.spec &>rpmbuild-bs.log' $BUILD_USER"
    rlRun "rlFileSubmit $TmpDir/rpmbuild-bs.log rpmbuild-bs.log"
    rlRun "yum-builddep -y -D \"_topdir $TmpDir\" $TmpDir/SRPMS/*.src.rpm &>$TmpDir/yum-builddep.log" 0,1; ret=$?
    rlRun "rlFileSubmit $TmpDir/yum-builddep.log yum-builddep.log"
    if [ $ret -ne 0 ]; then
      rlLogWarning "Dependencies was not successfully installed"
      rlLogInfo "Trying to install dependencies of bare SPEC file ..."
      rlRun "yum-builddep -y -D \"_topdir $TmpDir\" $TmpDir/SPECS/*.spec &>$TmpDir/yum-builddep-spec.log"
      rlRun "rlFileSubmit $TmpDir/yum-builddep-spec.log yum-builddep-spec.log"
    fi
    rlRun "su -c 'rpmbuild -D \"_topdir $TmpDir\" -bp $TmpDir/SPECS/*.spec &>$TmpDir/rpmbuild-bp.log' $BUILD_USER"
    rlRun "rlFileSubmit $TmpDir/rpmbuild-bp.log rpmbuild-bp.log"
    if test -e $TmpDir/BUILD/gdb-*/gnulib/configure; then
      rlRun "cd $TmpDir/BUILD/gdb-*/gnulib"
      rlRun "su -c 'bash ./configure &>$TmpDir/configure-gnulib.log' $BUILD_USER"
      rlRun "rlFileSubmit $TmpDir/configure-gnulib.log configure-gnulib.log"
    fi
    rlRun "configure_flags=\$(rpmspec -D \"_topdir $TmpDir\" -P $TmpDir/SPECS/*.spec | grep -o -E '\-\-(prefix|with\-gdb\-datadir|with\-separate\-debug\-dir|with\-python)=\S+' | tr '\n' ' ')"
    rlRun "cd $TmpDir/BUILD/gdb-*/gdb"
    rlRun "su -c './configure $configure_flags &>$TmpDir/configure.log' $BUILD_USER"
    rlRun "rlFileSubmit $TmpDir/configure.log configure.log"
    rlRun "DATADIR=`gdb -ex 'show data-directory' -batch | grep -o -E '/[^\"]+'`"
    rlRun "mv data-directory data-directory.orig"
    rlRun "ln -s $DATADIR ./data-directory"
  rlPhaseEnd

  rlPhaseStartSetup "filter testsuite"
    rlRun "system=`uname -r | grep -o -E 'el[0-9]+a?|fc[0-9]+'` && [[ ! -z \$system ]]"
    rlRun "ref_file=$TmpDir/ref/$PACKAGE/$system.`arch`"
    if ! test -e $ref_file; then
      rlLogWarning "Reference file $ref_file not found"
      rlLogInfo "Using default reference file ..."
      rlRun "ref_file=$TmpDir/ref/default"
    fi
    rlRun "test -e $ref_file"
    rlRun "cd testsuite"
    rlRun "find . -regex '^./gdb\..+\.exp$' -type f -printf '%P\n' | sort >$TmpDir/test_list"
    rlRun "comm -23 $TmpDir/test_list $ref_file >$TmpDir/disable_list"  # disable tests that are not included in the reference file
    rlLogInfo "Testcase disabling ..."
    while read file; do
      mv "$file" "$file.disabled"
    done <$TmpDir/disable_list
    rlRun "cd $TmpDir/BUILD/gdb-*/gdb"
  rlPhaseEnd

  rlPhaseStartTest "run testsuite"
    rlRun "su -c 'make check RUNTESTFLAGS=\"${RUNTESTFLAGS}\" |& tee $TmpDir/testsuite.log | grep -E \"^Running.+\.exp ...$\"; test \${PIPESTATUS[0]} -eq 0' $BUILD_USER"
    rlRun "rlFileSubmit $TmpDir/testsuite.log testsuite.log"
    rlRun "rlFileSubmit testsuite/gdb.sum gdb.sum"
    rlRun "rlFileSubmit testsuite/gdb.log gdb.log"
    rlLogInfo "`awk '/=== gdb Summary ===/,0' testsuite/gdb.sum`"
  rlPhaseEnd

  rlPhaseStartTest "evaluate results"
    rlRun "tests_count=\$(grep -E '^PASS:' testsuite/gdb.sum | wc -l)"
    [ "$tests_count" -ge "$TESTS_COUNT_MIN" ] && rlLogInfo "Test counter: $tests_count" || rlFail "Test counter $tests_count should be greater than or equal to $TESTS_COUNT_MIN"
    rlRun "awk 'BEGIN { RS=\"Running /tmp/[^/]+/BUILD/gdb-[^/]+/gdb/testsuite/\" } /\sERROR:|\sFAIL:|\sKPASS:|\sUNRESOLVED:|\sXPASS:/ { print \$0 }' testsuite/gdb.sum >$TmpDir/error.log"  # check for errors, unresolved testcases, unexpected failures and unexpected successes
    if [ -s $TmpDir/error.log ]; then
      rlFail "Errors observed";
      rlRun "rlFileSubmit $TmpDir/error.log error.log"
      rlRun "awk 'BEGIN { RS=\"Running /tmp/[^/]+/BUILD/gdb-[^/]+/gdb/testsuite/\" } /\sERROR:|\sFAIL:|\sKPASS:|\sUNRESOLVED:|\sXPASS:/ { print \$1 }' testsuite/gdb.sum >$TmpDir/affected_testcases.log"
      rlLogInfo "`echo 'Affected testcases:';cat $TmpDir/affected_testcases.log`"
      rlRun "rlFileSubmit $TmpDir/affected_testcases.log affected_testcases.log"
    else
      rlPass "No errors observed"
    fi
  rlPhaseEnd

  rlPhaseStartCleanup
    rlRun "cat $TmpDir/core_pattern.bckp >/proc/sys/kernel/core_pattern"
    rlRun "popd"
    rlRun "rm -r $TmpDir"
    [ "$del" = "yes" ] && rlRun "userdel -f $BUILD_USER"
  rlPhaseEnd
rlJournalPrintText
rlJournalEnd
