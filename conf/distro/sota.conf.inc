# This configuration snippet adds "sota" DISTRO_FEATURE and corresponding OVERRIDE.
#   you can use both depending on what is more convenient for your script.
#   The snippet was designed so that you can include it unconditionally
#   and disable all sota-related functionality if unneeded by adding
#      DISTRO_FEATURES_remove = "sota"
#   to your local.conf.

DISTRO_FEATURES_append = " sota"
OVERRIDES .= "${@bb.utils.contains(DISTRO_FEATURES, 'sota', ':sota', '', d)}"

IMAGE_INSTALL_append_sota = " ostree os-release"

# live image for OSTree-enabled systems
IMAGE_CLASSES_append_sota = " image_types_ostree image_types_ota"
IMAGE_FSTYPES += "${@bb.utils.contains(DISTRO_FEATURES, 'sota', ' ostreepush otaimg wic', '', d)"

WKS_FILE_sota ?= "sdimage-sota.wks"
SOTA_WIC_PAYLOAD_sota = "${IMAGE_BASENAME}:do_image_otaimg"
do_image_wic[depends] += " ${SOTA_WIC_PAYLOAD}"

EXTRA_IMAGEDEPENDS_append_sota = " parted-native mtools-native dosfstools-native"

# Please redefine OSTREE_REPO in order to have a persistent OSTree repo
OSTREE_REPO ?= "${DEPLOY_DIR_IMAGE}/ostree_repo"
OSTREE_BRANCHNAME ?= "ota-${MACHINE}"
OSTREE_OSNAME ?= "poky"
OSTREE_INITRAMFS_IMAGE ?= "initramfs-ostree-image"

# Prelinking increases the size of downloads and causes build errors
USER_CLASSES_remove = "image-prelink"
