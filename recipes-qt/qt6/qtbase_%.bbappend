# recipes-qt/qt6/qtbase_%.bbappend
#
# Extends the upstream qtbase recipe from meta-qt6 to enable
# the display and GPU features required for Qt EGLFS on RPi5.
#
# This file is merged ON TOP of meta-qt6's qtbase recipe at
# BitBake parse time. The upstream recipe is never modified.

# ---------------------------------------------------------------
# PACKAGECONFIG — enable EGLFS display stack
# ---------------------------------------------------------------
# PACKAGECONFIG controls which optional features get compiled
# into Qt. Each entry maps to a cmake -D flag in the Qt build.
# We append our required features without removing upstream defaults.

PACKAGECONFIG:append = " \
    eglfs \
    kms \
    gbm \
    gles2 \
    fontconfig \
"

# eglfs      — Qt EGLFS platform plugin
#              Enables qt's direct-to-display rendering path
#              Compiled in as: plugins/platforms/libqeglfs.so

# kms        — KMS/DRM backend for EGLFS (eglfs_kms)
#              Allows EGLFS to use kernel modesetting directly
#              Required on RPi5 — firmware KMS path is legacy/deprecated

# gbm        — Generic Buffer Management
#              GBM is the buffer allocation layer between EGL and DRM
#              EGLFS_KMS uses GBM to allocate GPU scanout buffers
#              Without GBM, eglfs_kms cannot create an EGL surface

# gles2      — OpenGL ES 2.0 support
#              Qt Quick scene graph renders via OpenGL ES
#              RPi5 V3D GPU supports GLES2/3 — this enables that path

# fontconfig — System font discovery
#              Without this Qt falls back to built-in fonts only
#              Needed for QML Text elements to find system fonts

# ---------------------------------------------------------------
# Explicitly disable features we do not need
# Reduces build time and binary size
# ---------------------------------------------------------------
PACKAGECONFIG:remove = " \
    xcb \
    xkbcommon \
    gtk3 \
    cups \
    icu \
"

# xcb        — X11/XCB platform plugin — we have no X server
# xkbcommon  — X keyboard extension — not needed without X11
# gtk3       — GTK platform theme — irrelevant for embedded QML app
# cups       — printing support — not needed on embedded target
# icu        — Unicode/locale library — large dependency, not needed
#              for a single-language embedded UI
