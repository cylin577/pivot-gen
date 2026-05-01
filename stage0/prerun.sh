#!/bin/bash -e

if [ "$RELEASE" != "trixie" ]; then
	echo "WARNING: RELEASE does not match the intended option for this branch."
	echo "         Please check the relevant README.md section."
fi

if [ ! -d "${ROOTFS_DIR}" ]; then
	case "${ARCH}" in
	armhf)
		bootstrap "${RELEASE}" "${ROOTFS_DIR}" http://raspbian.raspberrypi.com/raspbian/
		;;
	arm64)
		bootstrap "${RELEASE}" "${ROOTFS_DIR}" http://deb.debian.org/debian/
		;;
	*)
		echo "Unsupported ARCH: ${ARCH}" 1>&2
		exit 1
		;;
	esac
fi
