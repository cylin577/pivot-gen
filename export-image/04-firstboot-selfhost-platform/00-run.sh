#!/bin/bash -e

install -d "${ROOTFS_DIR}/usr/local/sbin"
install -m 755 files/firstboot-selfhost-platform "${ROOTFS_DIR}/usr/local/sbin/firstboot-selfhost-platform"

install -d "${ROOTFS_DIR}/usr/local/bin"
case "${ARCH}" in
arm64)
	curl -fsSL "https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.aarch64" \
		-o "${ROOTFS_DIR}/usr/local/bin/ttyd"
	;;
*)
	echo "Unsupported ARCH for bundled ttyd binary: ${ARCH}" 1>&2
	exit 1
	;;
esac
chmod 755 "${ROOTFS_DIR}/usr/local/bin/ttyd"

install -d "${ROOTFS_DIR}/etc/systemd/system"
install -m 644 files/firstboot-selfhost-platform.service "${ROOTFS_DIR}/etc/systemd/system/firstboot-selfhost-platform.service"
install -m 644 files/firstboot-selfhost-platform-ttyd.service "${ROOTFS_DIR}/etc/systemd/system/firstboot-selfhost-platform-ttyd.service"

install -d "${ROOTFS_DIR}/etc/update-motd.d"
install -m 755 files/99-firstboot-selfhost-platform "${ROOTFS_DIR}/etc/update-motd.d/99-firstboot-selfhost-platform"

on_chroot <<-'EOF'
	mkdir -p /var/lib
	systemctl enable firstboot-selfhost-platform.service
	systemctl enable firstboot-selfhost-platform-ttyd.service
EOF
