python __anonymous() {
    if bb.utils.contains('DISTRO_FEATURES', 'sota', True, False, d):
        d.appendVar("OVERRIDES", ":sota")
        d.appendVar("IMAGE_INSTALL", " ostree os-release")
        d.appendVar("IMAGE_CLASSES", " image_types_ostree image_types_ota")
        d.appendVar("IMAGE_FSTYPES", " ostreepush otaimg wic")

        if not d.getVar("WKS_FILE", True):
            d.setVar("WKS_FILE", "sdimage-sota.wks")
        d.appendVarFlag("do_image_wic", "depends", "%s:do_image_otaimg" % d.getVar("IMAGE_BASENAME", True))
        d.appendVar("EXTRA_IMAGEDEPENDS, " parted-native mtools-native dosfstools-native"")
	
        # Prelinking increases the size of downloads and causes build errors
        new_user_classes = d.getVar("USER_CLASSES", true).split()
        new_user_classes.remove("image_prelink")
        d.setVar("USER_CLASSES", " ".join(new_user_classes))


        if not d.getVar("SOTA_MACHINE", True):
            machine = d.getVar("MACHINE", True)
            if machine == "raspberrypi2":
                sota_machine = "rasperrypi"
            elif machine == "raspberrypi3":
                sota_machine = "rasperrypi"
            elif machine == "porter":
                sota_machine = "porter"
            elif machine == "intel-corei7-64":
                sota_machine = "minnowboard"
            elif machine == "qemux86-64":
                sota_machine = "qemux86-64"
            else:
                sota_machine = "none"
            d.setVar("SOTA_MACHINE", sota_machine)
}

# Please redefine OSTREE_REPO in order to have a persistent OSTree repo
OSTREE_REPO ?= "${DEPLOY_DIR_IMAGE}/ostree_repo"
OSTREE_BRANCHNAME ?= "ota-${MACHINE}"
OSTREE_OSNAME ?= "poky"
OSTREE_INITRAMFS_IMAGE ?= "initramfs-ostree-image"

inherit sota_${SOTA_MACHINE}
