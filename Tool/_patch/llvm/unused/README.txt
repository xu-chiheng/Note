
cygwin-CGExprCXX.cpp.patch
Fix the regression caused by commit 67409911353323ca5edf2049ef0df54132fa1ca7, that, in Cygwin, Clang can't bootstrap.

cygwin-Attributes.cpp.patch
Fix the regression caused by commit 8629343a8b6c26f15f02de2fdd8db440eba71937, that, in Cygwin, Clang can't bootstrap.

cygwin-Address.h.patch
Fix the regression caused by commit e419e22ff6fdff97191d132555ded7811c3f5b05, that, in Cygwin, Clang can't bootstrap, using GCC 13.2.0 as stage 0 compiler.

mingw-dynamicbase.patch
Not needed for MinGW.
https://github.com/llvm/llvm-project/pull/74979







mingw-git-revision-0.patch
MinGW Clang show git revision


E:\Note\Tool\llvm\clang\lib\Basic\Version.cpp


#include "VCSVersion.inc"
#include "llvm/Support/VCSRevision.h"


"include/VCSVersion.inc"
"Common/VCSVersion.inc"


E:\Note\Tool\llvm-cygwin-clang-release-build\include\llvm\Support\VCSRevision.h
E:\Note\Tool\llvm-mingw-ucrt-clang-release-build\include\llvm\Support\VCSRevision.h
#define LLVM_REVISION "42e8c349671949b4e46bd691bd0a33114a1bdbb8"
#define LLVM_REPOSITORY "git@github.com:xu-chiheng/llvm-project.git"


E:\Note\Tool\llvm-cygwin-clang-release-build\tools\clang\lib\Basic\VCSVersion.inc
#define LLVM_REVISION "42e8c349671949b4e46bd691bd0a33114a1bdbb8"
#define LLVM_REPOSITORY "git@github.com:xu-chiheng/llvm-project.git"
#define CLANG_REVISION "42e8c349671949b4e46bd691bd0a33114a1bdbb8"
#define CLANG_REPOSITORY "git@github.com:xu-chiheng/llvm-project.git"

E:\Note\Tool\llvm-mingw-ucrt-clang-release-build\tools\clang\lib\Basic\VCSVersion.inc
#undef LLVM_REVISION
#undef LLVM_REPOSITORY
#undef CLANG_REVISION
#undef CLANG_REPOSITORY

LLVM_REPOSITORY  LLVM_REVISION
generate_vcs_revision

**LLVM_APPEND_VC_REV**:BOOL
  Embed version control revision info (Git revision id).
  The version info is provided by the ``LLVM_REVISION`` macro in
  ``llvm/include/llvm/Support/VCSRevision.h``. Developers using git who don't
  need revision info can disable this option to avoid re-linking most binaries
  after a branch switch. Defaults to ON.


include(VersionFromVCS)

option(LLVM_APPEND_VC_REV
  "Embed the version control system revision in LLVM" ON)

set(LLVM_FORCE_VC_REVISION
  "" CACHE STRING "Force custom VC revision for LLVM_APPEND_VC_REV")

set(LLVM_FORCE_VC_REPOSITORY
  "" CACHE STRING "Force custom VC repository for LLVM_APPEND_VC_REV")



set(generate_vcs_version_script "${LLVM_CMAKE_DIR}/GenerateVersionFromVCS.cmake")

$ find . -name GenerateVersionFromVCS.cmake
./llvm/cmake/modules/GenerateVersionFromVCS.cmake

llvm\cmake\modules\VersionFromVCS.cmake




namespace clang {
  /// Retrieves the repository path (e.g., Subversion path) that
  /// identifies the particular Clang branch, tag, or trunk from which this
  /// Clang was built.
  std::string getClangRepositoryPath();

  /// Retrieves the repository path from which LLVM was built.
  ///
  /// This supports LLVM residing in a separate repository from clang.
  std::string getLLVMRepositoryPath();

  /// Retrieves the repository revision number (or identifier) from which
  /// this Clang was built.
  std::string getClangRevision();

  /// Retrieves the repository revision number (or identifier) from which
  /// LLVM was built.
  ///
  /// If Clang and LLVM are in the same repository, this returns the same
  /// string as getClangRevision.
  std::string getLLVMRevision();

  /// Retrieves the Clang vendor tag.
  std::string getClangVendor();

  /// Retrieves the full repository version that is an amalgamation of
  /// the information in getClangRepositoryPath() and getClangRevision().
  std::string getClangFullRepositoryVersion();

  /// Retrieves a string representing the complete clang version,
  /// which includes the clang version number, the repository version,
  /// and the vendor tag.
  std::string getClangFullVersion();

  /// Like getClangFullVersion(), but with a custom tool name.
  std::string getClangToolFullVersion(llvm::StringRef ToolName);

  /// Retrieves a string representing the complete clang version suitable
  /// for use in the CPP __VERSION__ macro, which includes the clang version
  /// number, the repository version, and the vendor tag.
  std::string getClangFullCPPVersion();
}
