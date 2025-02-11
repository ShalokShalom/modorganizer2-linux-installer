#!/usr/bin/env bash

missing_deps=()

if [ -z "$(command -v 7z)" ]; then
	missing_deps+=(7z)
fi

if [ -z "$(command -v curl)" ] && [ -z "$(command -v wget)" ]; then
	missing_deps+=("curl or wget")
fi

if [ -z "$(command -v protontricks)" ]; then
	if [ -n "$(command -v flatpak)" ]; then
		if flatpak info com.github.Matoking.protontricks > /dev/null; then
			using_flatpak_protontricks=1
		else
			missing_deps+=(protontricks)
		fi
	else
		missing_deps+=(protontricks)
	fi
else
	using_flatpak_protontricks=0
fi

if [ -z "$(command -v zenity)" ]; then
	missing_deps+=(zenity)
fi

if [ -n "${missing_deps[*]}" ]; then
	log_error "missing dependencies ${missing_deps[@]}"
	"$dialog" errorbox \
		"Your system is missing the following programs:\n$(printf '* %s\n' "${missing_deps[@]}")\n\nThey should be available in your distro's package manager.\nInstall them and try again."
	exit 1
fi

if [ ! -f "$redirector/main.exe" ]; then
	log_error "redirector binaries not found"
	exit 1
fi

log_info "all dependencies met"

