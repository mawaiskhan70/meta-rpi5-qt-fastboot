# recipes-core/images/rpi5-qt-fastboot-image.bb
#
# Minimum boot time Qt6 QML image for Raspberry Pi 5
# Display: Qt EGLFS direct KMS/DRM — no Weston, no X11
#
# Build with:
#   ./scripts/build.sh sd
#   ./scripts/build.sh sd bitbake rpi5-qt-fastboot-image

# ---------------------------------------------------------------
# Inherit the core image class
# This gives us IMAGE_INSTALL, IMAGE_FEATURES, rootfs assembly
# ---------------------------------------------------------------
inherit core-image

# ---------------------------------------------------------------
# Image description
# ---------------------------------------------------------------
SUMMARY = "Minimum boot time Qt6 QML UI image for Raspberry Pi 5"
DESCRIPTION = "Single-app Qt6 QML image using EGLFS direct KMS/DRM rendering. \
               No compositor. Optimized for minimum wall-clock boot time."
HOMEPAGE = "https://github.com/mawaiskhan70/meta-rpi5-qt-fastboot"

# ---------------------------------------------------------------
# Image features
# Controls high-level rootfs policies, not individual packages
# ---------------------------------------------------------------
IMAGE_FEATURES += " \
    debug-tweaks \
    ssh-server-openssh \
"
# debug-tweaks  — allows root login without password (development only)
# ssh-server-openssh — SSH access for development and package testing
# NOTE: Both will be removed in a production/optimized image later

# ---------------------------------------------------------------
# Core packages — minimum viable rootfs
# ---------------------------------------------------------------
IMAGE_INSTALL:append = " \
    packagegroup-core-boot \
    kernel-modules \
    linux-firmware-rpidistro \
"
# packagegroup-core-boot — busybox, base-files, base-passwd, sysvinit/systemd
# kernel-modules         — loadable kernel modules built alongside kernel
# linux-firmware-rpidistro — RPi GPU/WiFi firmware blobs (VC4 needs these)

# ---------------------------------------------------------------
# RPi5 hardware support
# ---------------------------------------------------------------
IMAGE_INSTALL:append = " \
    rpi-gpio \
    libraspberrypi \
    userland \
"
# rpi-gpio       — GPIO access from userspace
# libraspberrypi — Broadcom GPU userspace libraries
# userland       — RPi VideoCore utilities (vcgencmd, etc.)

# ---------------------------------------------------------------
# Qt6 — EGLFS stack
# ---------------------------------------------------------------
IMAGE_INSTALL:append = " \
    qtbase \
    qtdeclarative \
    qtquickcontrols2 \
    qtshadertools \
"
# qtbase           — Qt core + EGLFS platform plugin + KMS/GBM/EGL support
# qtdeclarative    — QML engine, Qt Quick scene graph renderer
# qtquickcontrols2 — ready-made QML UI controls (Button, Slider, etc.)
# qtshadertools    — Qt shader compilation tools (needed for Qt Quick effects)

# ---------------------------------------------------------------
# Your Qt QML application
# ---------------------------------------------------------------
IMAGE_INSTALL:append = " \
    rpi5-ui \
"
# rpi5-ui — your custom Qt QML app (recipe in recipes-app/rpi5-ui/)

# ---------------------------------------------------------------
# Image output format
# ---------------------------------------------------------------
IMAGE_FSTYPES = "ext4 wic.bz2 wic.bmap"
# ext4      — standard Linux filesystem for rootfs partition
# wic.bz2   — compressed flashable image (SD card / NVMe)
# wic.bmap  — block map file used by bmaptool for fast flashing
