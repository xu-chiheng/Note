#!/bin/bash
# vim: dict+=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   runtest.sh of /tools/cmake/Sanity/cmake-testsuite-sanity
#   Description: cmake testing by upstream testsuite
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

BUILD_USER=${BUILD_USER:-cmkbld}
TESTS_COUNT_MIN=${TESTS_COUNT_MIN:-50}
PACKAGE="cmake"
REQUIRES="$PACKAGE rpm-build"
if rlIsFedora; then
  REQUIRES="$REQUIRES dnf-utils"
else
  REQUIRES="$REQUIRES yum-utils"
fi
export CLICOLOR=0

rlJournalStart
  rlPhaseStartSetup
    rlShowRunningKernel
    rlAssertRpm --all
    rlRun "TmpDir=`mktemp -d`"
    rlRun "cp tests $TmpDir"
    rlRun "pushd $TmpDir"
    rlFetchSrcForInstalled $PACKAGE
    rlRun "useradd -M -N $BUILD_USER" 0,9
    [ "$?" == "0" ] && rlRun "del=yes"
    rlRun "chown -R $BUILD_USER:users $TmpDir"
  rlPhaseEnd

  rlPhaseStartSetup "build cmake"
    rlRun "rpm -D \"_topdir $TmpDir\" -U *.src.rpm"
    rlRun "dnf builddep -y $TmpDir/SPECS/*.spec"
    rlRun "su -c 'rpmbuild -D \"_topdir $TmpDir\" -bp $TmpDir/SPECS/*.spec &>$TmpDir/rpmbuild.log' $BUILD_USER"
    rlRun "rlFileSubmit $TmpDir/rpmbuild.log"
    rlRun "CMakeDir=`ls $TmpDir/BUILD | grep -E '^cmake-[0-9]+(\.[0-9]+)+(-rc[0-9]+)?$' | tail -n 1`"
    rlRun "cd $TmpDir/BUILD/$CMakeDir"
    rlRun "su -c './bootstrap &>$TmpDir/bootstrap.log' $BUILD_USER"
    rlRun "rlFileSubmit $TmpDir/bootstrap.log"
    rlRun "ln -fs /usr/bin/cmake bin/cmake"
    rlRun "make exit_code"
  rlPhaseEnd

  rlPhaseStartTest "run testsuite"
    while read test; do
      rlRun "su -c '/usr/bin/ctest -R \"$test\" &>>$TmpDir/testsuite.log' $BUILD_USER"
    done <$TmpDir/tests
    rlRun "rlFileSubmit $TmpDir/testsuite.log"
  rlPhaseEnd

  rlPhaseStartTest "evaluate results"
    rlRun "cd $TmpDir"
    rlRun "grep -E '\*\*\*(F|f)ailed' testsuite.log" 1 "There should be no failure"
    rlRun "tests_count=\$(grep -E 'Test #[0-9]+: .+\.\.\.   (P|p)assed' testsuite.log | wc -l)"
    [ "$tests_count" -ge "$TESTS_COUNT_MIN" ] && rlLogInfo "Test counter: $tests_count" || rlFail "Test counter $tests_count should be greater than or equal to $TESTS_COUNT_MIN"
  rlPhaseEnd

  rlPhaseStartCleanup
    rlRun "popd"
    rlRun "rm -r $TmpDir"
    [ "$del" == "yes" ] && rlRun "userdel -f $BUILD_USER"
  rlPhaseEnd
rlJournalPrintText
rlJournalEnd
