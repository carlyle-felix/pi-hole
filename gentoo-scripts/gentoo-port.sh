#!/bin/bash

# Get the directory of the current script
DIR_="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Point variable to previous directory
DIR_="${DIR_%/*}"

# Source the overlay.sh here
source "${DIR_}/gentoo-scripts/overlay.sh"

# Pi-hole dependency meta package for Portage based sys>
PIHOLE_META_PACKAGE_CONTROL_PORTAGE="pihole-meta"

# Unofficial note
gentoo_port_notice() {
	echo -e "\033[1;35;40m"
	echo -e ""
	echo -e "          UNOFFICIAL GENTOO PORT"
	echo -e "${COL_NC}"
	echo -e ""
}

gentoo_package_management() {
	local arg="$1"

	# Generate meta package repo
	if [[ "${arg}" == "generate_repo" ]]; then
		gentoo_generate_repo

	# set package manager variables
	elif [[ "${arg}" == "set_package_manager" ]]; then
		PKG_MANAGER="emerge"
		PKG_INSTALL="${PKG_MANAGER} -auv"
		PKG_REMOVE="${PKG_MANAGER} --deselect"

	# Install the meta package
	elif [[ "${arg}" == "install_meta" ]]; then
		eval "$PKG_INSTALL" "${PIHOLE_META_PACKAGE_CONTROL_PORTAGE}"

	# Remove the overlay when uninstalling pihole
	elif [[ "${arg}" == "remove_overlay" ]]; then
		${SUDO} rm -rf /var/db/repos/pihole-overlay &> /dev/null
		${SUDO} rm /etc/portage/repos.conf/pihole.conf
	fi
}