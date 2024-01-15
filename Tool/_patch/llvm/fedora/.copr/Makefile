# See https://docs.pagure.org/copr.copr/user_documentation.html#make-srpm
# See for the --setopt option in the enabling of copr repo see:
# https://pagure.io/copr/copr/issue/184

COPR_USERNAME=$(shell rpm --eval %copr_username)
COPR_PROJECT=$(shell rpm --eval %copr_projectname)

.PHONY: srpm
srpm:
	dnf install -y dnf-plugins-core fedora-packager
	dnf copr enable -y --setopt=reposdir=/tmp/yum.repos.d $(COPR_USERNAME)/$(COPR_PROJECT)
	dnf install -y --setopt=reposdir=/tmp/yum.repos.d llvm-snapshot-builder
	rpmbuild \
		--define "_srcrpmdir $(outdir)" \
		--define "_sourcedir $(shell pwd)" \
		--define "_disable_source_fetch 0" \
		-bs $(spec)
