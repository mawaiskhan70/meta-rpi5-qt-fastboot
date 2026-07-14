# recipes-qt/qt6/qtbase_%.bbappend
#
# Extends upstream qtbase recipe from meta-qt6
# :class-target ensures these settings only apply to the ARM target build
# NOT to qtbase-native (host build tools)

# ---------------------------------------------------------------
# Enable EGLFS stack — TARGET build only
# ---------------------------------------------------------------
PACKAGECONFIG:append:class-target = " \
    eglfs \
    kms \
    gbm \
    gles2 \
    fontconfig \
"

# ---------------------------------------------------------------
# Disable unused features — TARGET build only
# ---------------------------------------------------------------
PACKAGECONFIG:remove:class-target = " \
    xcb \
    xkbcommon \
    gtk3 \
    cups \
    icu \
"
