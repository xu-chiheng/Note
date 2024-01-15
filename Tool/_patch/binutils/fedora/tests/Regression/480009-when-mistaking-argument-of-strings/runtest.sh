#!/bin/bash
# vim: dict=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
#
# Copyright (c) 2009 Red Hat, Inc. All rights reserved.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# 
# Author: Michal Nowak <mnowak@redhat.com>

# source the test script helpers
. /usr/share/beakerlib/beakerlib.sh || exit 1

PACKAGE=binutils

rlJournalStart
	rlPhaseStartSetup
		rlShowPackageVersion $PACKAGE
		rlShowRunningKernel
	rlPhaseEnd

	rlPhaseStartTest "#1: strings -n file1"
		rlRun "strings -n file1 2>&1 | grep 'invalid integer argument file1'" 0 "Produced expected error msg: 'strings: invalid integer argument file1'"
	rlPhaseEnd

	rlPhaseStartTest "#2: strings --bytes file1"
		rlRun "strings --bytes file1 2>&1 | grep 'invalid integer argument file1'" 0 "Produced expected error msg: 'strings: invalid integer argument file1'"
	rlPhaseEnd

	rlPhaseStartTest "#3: strings -n 0"
		rlRun "strings -n 0 2>&1 | grep 'minimum string length is too small: 0'" 0 "Produced expected error msg: 'minimum string length is too small: 0'"
	rlPhaseEnd

	rlPhaseStartTest "#4: strings --bytes 0"
		rlRun "strings --bytes 0 2>&1 | grep 'minimum string length is too small: 0'" 0 "Produced expected error msg: 'minimum string length is too small: 0'"
	rlPhaseEnd

	rlJournalPrintText
rlJournalEnd
