#!/bin/bash -e
if [ "${ARCH}" = "armhf" ]; then
	on_chroot << EOF
apt-get -o Acquire::Retries=3 install -y raspi-copies-and-fills
EOF
fi
