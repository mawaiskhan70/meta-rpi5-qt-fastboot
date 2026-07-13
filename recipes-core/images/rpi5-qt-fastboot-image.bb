# recipes-core/images/rpi5-qt-fastboot-image.bb
inherit core-image

SUMMARY = "Minimum boot time Qt6 QML UI image for Raspberry Pi 5"
DESCRIPTION = "Single-app Qt6 QML image using EGLFS direct KMS/DRM rendering. \
               No compositor. Optimized for minimum wall-clock boot time."
HOMEPAGE = "https://github.com/mawaiskhan70/meta-rpi5-qt-fastboot"

# ---------------------------------------------------------------
# Image features
# ---------------------------------------------------------------
IMAGE_FEATURES += " \
    debug-tweaks \
    ssh-server-openssh \
"

# ---------------------------------------------------------------
# Core packages
# ---------------------------------------------------------------
IMAGE_INSTALL:append = " \
    packagegroup-core-boot \
    kernel-modules \
"

# ---------------------------------------------------------------
# RPi5 WiFi firmware — split packages, no top-level meta-package
# BCM43455 is the onboard WiFi chip on RPi5
# ---------------------------------------------------------------
IMAGE_INSTALL:append = " \
    linux-firmware-rpidistro-bcm43455 \
    linux-firmware-rpidistro-bcm43456 \
    linux-firmware-rpidistro-module-conf \
"

# ---------------------------------------------------------------
# RPi5 hardware support
# ---------------------------------------------------------------
IMAGE_INSTALL:append = " \
    rpi-gpio \
    userland \
"

# ---------------------------------------------------------------
# Qt6 EGLFS stack
# ---------------------------------------------------------------
IMAGE_INSTALL:append = " \
    qtbase \
    qtdeclarative \
    qtshadertools \
"

# ---------------------------------------------------------------
# Application — commented out until first boot verified
# ---------------------------------------------------------------
# IMAGE_INSTALL:append = " rpi5-ui"

# ---------------------------------------------------------------
# Image output format
# ---------------------------------------------------------------
IMAGE_FSTYPES = "ext4 wic.bz2 wic.bmap"
