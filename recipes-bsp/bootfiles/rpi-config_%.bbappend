# recipes-bsp/bootfiles/rpi-config_%.bbappend
#
# Extends meta-raspberrypi's rpi-config recipe to inject
# RPi5-specific settings into /boot/config.txt
#
# Two categories of settings here:
#   1. Display stack — enables VC4 KMS/DRM for EGLFS
#   2. Boot speed    — removes unnecessary firmware probes

# ---------------------------------------------------------------
# Display stack — CRITICAL for EGLFS to work
# ---------------------------------------------------------------
# Enable the VC4/V3D KMS driver overlay
# This tells the firmware to hand display control to the kernel
# via DRM/KMS instead of keeping it in the firmware (legacy path)
#
# Without this overlay:
#   - /dev/dri/card0 does not exist
#   - EGLFS cannot open the DRM device
#   - Qt app crashes immediately with "Could not open DRM device"
#
ENABLE_DRM_VC4 = "1"

# ---------------------------------------------------------------
# Boot speed optimizations via RPI_EXTRA_CONFIG
# These are appended to config.txt by meta-raspberrypi
# ---------------------------------------------------------------
# NOTE: boot_delay, disable_splash, camera_auto_detect=0 and
# display_auto_detect=0 are already set in kas/rpi5-sd.yml via
# RPI_EXTRA_CONFIG. They are NOT repeated here to avoid duplication.
#
# This bbappend only adds settings that are layer-level concerns
# (display stack) not build-config-level concerns (kas YAML).

RPI_EXTRA_CONFIG:append = " \
    dtparam=audio=off \n \
    dtoverlay=disable-bt \n \
"

# dtparam=audio=off   — disables the onboard audio subsystem
#                       Audio driver init adds measurable boot time
#                       Not needed for a display-only Qt UI

# dtoverlay=disable-bt — disables Bluetooth completely
#                        Bluetooth firmware load happens early in boot
#                        Removing it saves firmware loading time
#                        Also disables the associated UART takeover
#                        freeing UART0 for your debug console (minicom)
