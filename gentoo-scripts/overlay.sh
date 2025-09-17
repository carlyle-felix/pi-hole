#!/bin/bash
# This script creates the meta package that contains all the dependencies needed for Pi-hole

# Write the config in place
function gentoo_write_config() {
	# Config location
	local pihole_conf="/etc/portage/repos.conf/pihole.conf"

	# Write config
	cat << EOF > "${pihole_conf}"
[pihole-overlay]
location = /var/db/repos/pihole-overlay
auto-sync = false
EOF
}

# Generate the repo in place
function gentoo_generate_repo() {
	# Repo location
	local repo_dir="/var/db/repos/pihole-overlay"

	# Initialize repo directory variables
	local metadata="${repo_dir}/metadata"
	local pihole_meta="${repo_dir}/net-dns/pihole-meta"
	local profiles="${repo_dir}/profiles"

	# Write/overwrite the repo config in repos.conf
	gentoo_write_config

	# Remove the old repo
	if [[ -d "${repo_dir}" ]]; then
		rm -rf "${repo_dir}"
	fi

	# Create new directories
	mkdir "${repo_dir}"
	mkdir "${metadata}"
	mkdir -p "${pihole_meta}"
	mkdir "${profiles}"

	# Write files into repo
	#	metadata/layout.conf
	cat << EOF > "${metadata}/layout.conf"
repo-name = pihole-overlay
masters = gentoo
thin-manifests = true
sign-manifests = false
EOF

	# net-dns/pihole-meta/pihole-meta-0.1.ebuild
	cat << EOF > "${pihole_meta}/pihole-meta-0.1.ebuild"
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2 

EAPI=8

DESCRIPTION="A metapackage for Pi-hole dependencies."
HOMEPAGE="https://github.com/carlyle-felix/pi-hole"
LICENSE="metapackage"
SLOT="0"
KEYWORDS="amd64 arm64"
RDEPEND="
        app-admin/sudo
        app-alternatives/awk
        app-arch/unzip
        app-misc/ca-certificates
        app-misc/jq
        app-shells/bash-completion
        dev-util/dialog
        dev-vcs/git
        net-analyzer/openbsd-netcat
        net-dns/bind-tools
        net-dns/dnssec-root
        net-misc/curl
        net-misc/iputils
        sys-apps/grep
        sys-apps/iproute2
        sys-apps/lshw
        sys-devel/binutils
        sys-libs/libcap
        sys-process/procps
        sys-process/psmisc
        virtual/cron
"
EOF

	# profiles/eapi
	cat << EOF > "${profiles}/eapi"
8
EOF

	# Make portage the owner of the repo
	chown -R portage:portage "${repo_dir}"
}
