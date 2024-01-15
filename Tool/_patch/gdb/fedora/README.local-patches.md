# Fedora GDB local patches policy

In order to make things easier for the Fedora GDB maintainer, we
choose to auto-generate the local patches by making use of an upstream
git repository.  Below you can find a few instructions on how to work
using this method.

You need to run the following commands from the directory that
contains the "gdb.spec" file.

## Importing the GDB patches into a git repository

1) The local patches (`*.patch`) need to be imported into an upstream
git repository.  For example, let's assume you cloned the repository
by doing:

`$ git clone git://sourceware.org/git/binutils-gdb.git`

> TIP: if you already have the repository cloned somewhere in your
> system, you can pass a "--reference <dir>" to the "git clone"
> command and it will use your local repository as much as possible
> to make the clone, speeding up things.

2) After cloning the upstream repository, you can import your patches
by using the script "generate-git-repo-from-patches.sh":

`$ sh generate-git-repo-from-patches.sh <REPOSITORY_DIR>`

The script will basically cd into the repository, checkout the
revision specified in the file `_git_upstream_commit`, iterate through
the file `_patch_order` and "git-am" every patch *in that order*.
This operation should complete without errors; if you find a problem
with `git-am`, it probably means that the revision specified in the
file `_git_upstream_commit` is wrong.

## Rebasing the patches against a newer version/release

1) First, cd into the upstream repository.  All you have to do is
choose the revision against which you plan to rebase the patches, and
`git rebase <REVISION>`.  git will do the rest, and you will be able
to perform conflict resolution by git's algorithm, which is smarter.

## Creating new patches

1) Create the new patch on top of the the others, as usual.  Note that
you can use `git rebase` whenever you want to reorder patch order, or
even to delete a patch.

2) When writing the commit log, you must obey a few rules.  The
subject line *must* be the filename of the patch.  This line will be
used when exporting the patches from the git repository, and
(obviously) it gives the filename that should be used for this
specific patch.

3) You can also add comments that will go into the auto-generated
`Patch:` file (see below).  To do that, use the special marker `;;` at
the beginning of the line.  This way, a commit log that says:

~~~~~~~~~~~
  test-patch.patch

  ;; This is a test patch
  ;; Second line
~~~~~~~~~~~

Will generate the following entry in the auto-generated `Patch:` file:

~~~~~~~~~~~
  # This is a test patch
  # Second line
  PatchXYZ: test-patch.patch
~~~~~~~~~~~

## Exporting the GDB patches from the git repository

1) When you're done working with the patches, go back to the directory
that contains the `gdb.spec` file, and from there you run:

`$ sh generate-patches-from-git-repo.sh <REPOSITORY_DIR>`

This will regenerate all of the `*.patch` files (excluding the ones that
were also excluded from the git repository), and also regenerate a few
control files.  These control files are:

  - `_gdb.spec.Patch.include`: This file contains the `Patch:` directives.

  - `_gdb.spec.patch.include`: This file contains the `%patch` directives.

  - `_patch_order`: This file contains the patches, in the exact order
    that they must be applied.  It is used when importing the patches
    into the git repository.

  - `_git_upstream_commit`: This file contains the last upstream commit
    against which the patches were rebased.  It is used when importing
    the patches into the git repository.

NOTE: If you did a rebase against a newer upstream version, you need
to specify the commit/tag/branch against which you rebased:

`$ sh generate-patches-from-git-repo.sh <REPOSITORY_DIR> <COMMIT_OR_TAG_OR_BRANCH>`

For example, if you rebased against `gdb-8.1-release`:

`$ sh generate-patches-from-git-repo.sh <REPOSITORY_DIR> gdb-8.1-release`
