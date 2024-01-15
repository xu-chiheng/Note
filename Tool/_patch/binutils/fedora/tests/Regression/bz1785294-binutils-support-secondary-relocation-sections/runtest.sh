#!/bin/bash
# vim: dict+=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   runtest.sh of /tools/binutils/Regression/bz1785294-binutils-support-secondary-relocation-sections
#   Description: Test for BZ#1785294 (binutils support secondary relocation sections)
#   Author: Edjunior Machado <emachado@redhat.com>
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   Copyright (c) 2020 Red Hat, Inc.
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

OBJCOPY="${OBJCOPY:-$(which objcopy)}"
READELF="${READELF:-$(which readelf)}"
PACKAGE=$(rpm --qf '%{name}\n' -qf $(which $READELF) | head -1)
PACKAGES=${PACKAGE}

rlJournalStart
    rlPhaseStartSetup
        rlLogInfo "PACKAGES=$PACKAGES"
        rlLogInfo "COLLECTIONS=$COLLECTIONS"
        rlLogInfo "OBJCOPY=$OBJCOPY"
        rlLogInfo "READELF=$READELF"
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

        rlRun "SOURCE_DIR=$(pwd)"
        rlRun "TmpDir=\$(mktemp -d)" 0 "Creating tmp directory"
        rlRun "pushd $TmpDir"
    rlPhaseEnd

    rlPhaseStart FAIL "Check support"
        rlRun "ARCH=$(arch)"
        case "$ARCH" in
            x86_64 | ppc64le)
                KO_FILE="${SOURCE_DIR}/kpatch-3_10_0-1062-1-15.${ARCH}.ko"
                rlLogInfo "KO_FILE=$KO_FILE"
                HAS_SUPPORT=1
                ;;
            *)
                rlLogWarning "Feature not supported on $ARCH"
                HAS_SUPPORT=0
                ;;
        esac
    rlPhaseEnd

if [ $HAS_SUPPORT = 1 ]; then
    rlPhaseStartTest
        rlAssertExists $KO_FILE
        rlRun "set -o pipefail" 0 "Conserve the non-zero return value through the pipe"

        # As suggested by nickc@redhat.com:
        rlRun "objcopy $KO_FILE copy.ko"
        rlRun "readelf --wide --section-headers copy.ko |& tee readelf_headers.out"
        rlRun -l "grep \".klp.rela.vmlinux.*\ RELA\ \" readelf_headers.out"

        # And as suggested by joe.lawrence@redhat.com:
        rlRun "readelf --wide --relocs $KO_FILE |& tee readelf_relocs.out"
        rlRun -l "awk \"/^Relocation section '.klp/\" RS='\n\n' ORS='\n\n' readelf_relocs.out"
        rlRun -l "grep \"^Relocation section '.klp\" readelf_relocs.out"

        rlRun "readelf --wide --symbols $KO_FILE |& tee readelf_symbols.out"
        # Section index for these symbols must be SHN_LIVEPATCH (0xff20)
        rlRun -l "grep '\[0xff20\]\ \.klp\.sym' readelf_symbols.out"

        rlRun "tar czvf readelf_outputs.tar.gz readelf_headers.out readelf_relocs.out readelf_symbols.out"
        rlFileSubmit readelf_outputs.tar.gz "${PACKAGE}-readelf_outputs.tar.gz"
    rlPhaseEnd
fi

    rlPhaseStartCleanup
        rlRun "popd"
        rlRun "rm -r $TmpDir" 0 "Removing tmp directory"
    rlPhaseEnd
rlJournalPrintText
rlJournalEnd
