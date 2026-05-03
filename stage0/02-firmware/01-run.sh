#!/bin/bash -e

case "${ARCH}" in
armhf)
	PACKAGES="linux-image-rpi-v6 linux-image-rpi-v7 linux-headers-rpi-v6 linux-headers-rpi-v7"
	;;
arm64)
	PACKAGES="linux-image-rpi-v8 linux-headers-rpi-v8"
	;;
*)
	echo "Unsupported ARCH: ${ARCH}" 1>&2
	exit 1
	;;
esac

on_chroot << EOF
apt-get -o Acquire::Retries=3 install -y ${PACKAGES}
EOF
