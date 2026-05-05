#!/bin/bash -e

on_chroot << EOF
mkdir -p /opt/pivot
git clone https://github.com/cylin577/pivot /opt/pivot/src || true
EOF
