#   Copyright (c) 2009 Red Hat, Inc. All rights reserved.
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
# Testcases for this bugzilla were provided by Jakub Jelinek <jakub@redhat.com>
# I've only wrapped them to RHTS

TOPLEVEL_NAMESPACE=/tools
PACKAGE_NAME=binutils
RELATIVE_PATH=bugzillas/241252

export TESTVERSION=1.0

export TEST=$(TOPLEVEL_NAMESPACE)/$(PACKAGE_NAME)/$(RELATIVE_PATH)

.PHONY: all install download clean

FILES=$(METADATA) \
	runtest.sh \
	Makefile \
	x.i \
	y.i

run: $(FILES) #build
	./runtest.sh

build: $(BUILT_FILES)
	chmod a+x ./runtest.sh

clean:
	rm -f *~ $(BUILT_FILES)

include /usr/share/rhts/lib/rhts-make.include

$(METADATA): Makefile
	@touch $(METADATA)
	@echo "Owner:        Michal Nowak <mnowak@redhat.com>" > $(METADATA)
	@echo "Name:         $(TEST)" >> $(METADATA)
	@echo "Path:         $(TEST_DIR)"	>> $(METADATA)
	@echo "TestVersion:  $(TESTVERSION)"	>> $(METADATA)
	@echo "Description:  Regression test for bz241252." >> $(METADATA)
	@echo "TestTime:     3m" >> $(METADATA)
	@echo "RunFor:       $(PACKAGE_NAME)" >> $(METADATA)
	@echo "Requires:     $(PACKAGE_NAME) gcc" >> $(METADATA)
	@echo "Priority:	Normal" >> $(METADATA)
	@echo "Type:		Regression" >> $(METADATA)
	@echo "Releases:	-RHEL4" >> $(METADATA)
	@echo "License:		GPLv2" >> $(METADATA)

	rhts-lint $(METADATA)
