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
$0 -- Generate a git repository from .patch files

Usage:
  $0 [-u] [-h] <REPOSITORY>

<REPOSITORY> is the directory where the rebase was performed.  You
need to clone the repository first.

Options are:

  -h: Print this message
  -u: Uncommit all patches and initialize stgit repo
EOF
    exit 0
}

test -f gdb.spec || die "This script needs to run from the same directory as gdb.spec."

test -z $1 && die "You need to specify the repository."
test "$1" = "-h" && usage

uncommit=0
if [ "$1" = "-u" ]; then
    command -v stg > /dev/null 2>&1  \
	|| die "Cannot find stg.  Is stgit installed?"
    uncommit=1
    shift
fi

git_repo=$1
if [ ! -e $git_repo ]; then
    echo "$0: repository \"$git_repo\" does not exist"
    exit 1
fi

test -f _git_upstream_commit || die "Cannot find _git_upstream_commit file."
test -f _patch_order || die "Cannot find _patch_order file."

last_ancestor_commit=`cat _git_upstream_commit`

f=`pwd`
cd $1

git name-rev $last_ancestor_commit
test $? -eq 0 || die "Could not find $last_ancestor_commit in the repository $1.  Did you run 'git fetch'?"


# Create a branch for the checkout if using stgit; use the distro name in
# the name of this branch.
if (($uncommit)); then
    name=devel-`basename $f`
    branch="-b $name"
else
    branch=""
fi
git checkout $branch $last_ancestor_commit

echo "Applying patches..."
for p in `cat $f/_patch_order` ; do
    git am $f/$p
    test $? -eq 0 || die "Could not apply patch '$p'."
done

if (($uncommit)); then
    echo "Uncommitting patches..."
    stg init
    stg uncommit -t $last_ancestor_commit -x
fi
