#!/usr/bin/env bash

# Fedora CI testing systems don't provide a repository with the i686
# RPMs of the build being tested. As a consequence, most
#   dnf install -y <some-gcc-rpm>.i686
# commands (whether being run by a test or by TMT's prepare) will probably
# fail on a version mismatch with the present x86_64 gcc RPMs. To prevent
# such failures we provide this script which we recommend to include in every
# Fedora CI test plan.
#
# Implementation notes:
#
# * The gcc build being tested in Fedora CI is given via KOJI_TASK_ID. See
#   https://github.com/fedora-ci/dist-git-pipeline/pull/50 for details.
#
# * Currently this script just downloads and installs the i686 RPMs. It
#   would not be sufficient for tests that uninstall and reinstall those
#   RPMs. If such a test appears, this script should create a repository.
#
# * Fedora CI testing systems seem to have extremely small RAM-based /tmp,
#   unable to host all the downloaded RPMs, and no other "real" filesystem
#   than "/". That's the reason for using
#     mktemp -d --tmpdir=/

set -x

true "V-V-V-V-V-V-V-V-V-V-V-V-V-V-V-V-V-V-V-V-V-V-V-V-V-V-V-V-V-V-V-V-V-V-V"

echo "KOJI_TASK_ID=$KOJI_TASK_ID"

. /etc/os-release

echo "ID=$ID"
echo "arch=$(arch)"
echo "KOJI_TASK_ID=$KOJI_TASK_ID"

if [[ "$ID" = fedora ]] && [[ "$(arch)" = x86_64 ]] && [[ -n "$KOJI_TASK_ID" ]]; then

    if tmpd=$(mktemp -d --tmpdir=/) && pushd "$tmpd"; then

        # Download
        rpm -q koji || dnf -y install koji
        koji download-task "$KOJI_TASK_ID" --noprogress --arch={x86_64,i686,noarch}

        # Remove conflicting RPMs
        rm -f ./*debuginfo* ./*debugsource*
        rm -f gcc-[0-9]*.i686.*
        rm -f ./*docs*.i686.*

        # Install
        ls
        dnf -y install ./*.rpm

        # Clean up
        # shellcheck disable=SC2164
        popd
        rm -rf "$tmpd"
    fi

else
    echo "Not applicable"
fi

true "^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^"
