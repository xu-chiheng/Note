#!/bin/sh

# Generic function to print an error message and bail out.
die ()
{
    echo $1 > /dev/stderr
    exit 1
}

# Print usage
usage ()
{
    cat <<EOF
$0 -- Generate .patch files for a RPM package from a git repository

Usage:
  $0 <REPOSITORY> [<COMMIT_OR_TAG_OR_BRANCH>]

<REPOSITORY> is the directory where the rebase was performed.

<COMMIT_OR_TAG_OR_BRANCH> is the commit or tag or branch against which
the rebase was performed.  It generally just needs to be provided if
the file "_git_upstream_commit" doesn't exist, or if you are doing a
rebase.  This script will then use 'git merge-base' to find the most
recent common ancestor between HEAD and COMMIT_OR_TAG_OR_BRANCH.

Options are:

  -h: Print this message
EOF
    exit 0
}

test -f gdb.spec || die "This script needs to run from the same directory as gdb.spec."

test -z $1 && die "You need to specify the repository."
test "$1" = "-h" && usage

commit_or_tag="`cat _git_upstream_commit`"
if test ! -z "$2" ; then
    commit_or_tag="$2"
fi

test -z $commit_or_tag && die "Because the '_git_upstream_commit' file doesn't exist, you need to specify a commit/tag/branch."

test -d $1 || die "$1 is not a directory."

# Remove all the current patches
for f in `cat _patch_order` ; do
    git rm -f $f
done

orig_dir=`pwd`
cd $1

# If patches were uncommitted when the patches were applied,
# make sure that we're sitting at the top-most patch.  Otherwise
# we'll only add patches up to the current top patch.
# It's safe to just assume stgit was used -- the push will simply
# fail.
stg push --all > /dev/null 2>&1

git name-rev $commit_or_tag
test $? -eq 0 || die "Could not find $commit_or_tag in the repository.  Did you run 'git fetch'?"

idx=1
common_ancestor=`git merge-base HEAD $commit_or_tag`

test -z "$common_ancestor" && die "Could not find common ancestor between HEAD and $commit_or_tag."

temp_PATCH_file=/tmp/_gdb.spec.Patch.include
temp_patch_file=/tmp/_gdb.spec.patch.include
temp_patch_order_file=/tmp/_patch_order

rm -f $temp_PATCH_file $temp_patch_file $temp_patch_order_file

for c in `git rev-list --reverse ${common_ancestor}..HEAD` ; do
    fname=`git log -1 --pretty='format:%s' $c`
    test -z $fname && die "Could not determine filename for commit $c."
    # Because git-format-patch generates patches with the first line
    # containing the commit hash, every time we do a git-format-patch
    # here we will have a different .patch file from what we had
    # before, even if nothing has changed.  This is bad, so we replace
    # the commit hash by something constant (the string
    # "FEDORA_PATCHES").
    git format-patch --no-base --no-thread --no-signature --no-stat \
        --keep-subject -1 --stdout $c \
        | sed -e '1 s/^From [0-9a-f]\+ \(.*\)/From FEDORA_PATCHES \1/' \
              -e '/^index [0-9a-f]\+\.\.[0-9a-f]\+.*$/d' > $orig_dir/$fname
    (cd $orig_dir && git add $fname)

    cat >> $temp_PATCH_file <<EOF
`git log -1 --pretty='format:%b' $c | sed -n 's/^;;/#/p'`
EOF
    printf "Patch%03d: %s\n\n" $idx $fname >> $temp_PATCH_file
    printf "%%patch -p1 -P%03d\n" $idx >> $temp_patch_file
    echo $fname >> $temp_patch_order_file
    idx=`expr $idx + 1`
done

cd $orig_dir
mv $temp_PATCH_file _gdb.spec.Patch.include
mv $temp_patch_file _gdb.spec.patch.include
mv $temp_patch_order_file _patch_order
echo "$common_ancestor" > _git_upstream_commit
