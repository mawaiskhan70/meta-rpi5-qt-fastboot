# recipes-kernel/linux/linux-raspberrypi_%.bbappend
#
# Extends meta-raspberrypi's linux-raspberrypi kernel recipe
# to apply our boot-time optimization kernel config fragment.
#
# The fragment is merged ON TOP of the RPi5 base defconfig
# at kernel build time — base config is never modified.

# ---------------------------------------------------------------
# Apply our kernel config fragment
# ---------------------------------------------------------------
# SRC_URI:append adds our .cfg fragment to the list of sources
# BitBake fetches and applies automatically during do_kernel_configme
SRC_URI:append = " file://rpi5-fastboot.cfg"

# ---------------------------------------------------------------
# Tell BitBake where to find the fragment file
# FILESEXTRAPATHS is searched before the default paths
# prepend (not append) ensures our path takes priority
# ---------------------------------------------------------------
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
