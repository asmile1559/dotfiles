# Module: flatpak -- Flatpak runtime and Flatseal.
# shellcheck shell=bash
install_packages_direct flatpak
flatpak_setup
flatpak_install_from "$PKG_DIR/flatpak.list"
