#!/bin/bash

# Get the directory of the current script
DIR_="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Point variable to previous directory
DIR_="${DIR_%/*}"

# Source the overlay.sh here
source "${DIR_}/gentoo-scripts/overlay.sh"

# Pi-hole dependency meta package for Portage based sys>
PIHOLE_META_PACKAGE_CONTROL_PORTAGE="pihole-meta"

gentoo_package_management() {
	local arg="$1"

	if [[ "${arg}" == "generate_repo" ]]; then
		# Generate meta package repo
		gentoo_generate_repo
	elif [[ "${arg}" == "set_package_manager" ]]; then
		# set package manager variables
		PKG_MANAGER="emerge"
		PKG_INSTALL="${PKG_MANAGER} -avn"
		PKG_REMOVE="${PKG_MANAGER} --deselect"
	elif [[ "${arg}" == "install_meta" ]]; then
		eval "$PKG_INSTALL" "${PIHOLE_META_PACKAGE_CONTROL_PORTAGE}"
	fi
}