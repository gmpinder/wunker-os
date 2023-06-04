#!/usr/bin/env bash
set -oue pipefail

dnf install git gcc-c++ pkgconfig libusb1-devel boost-devel systemd-devel dbus-devel python3-scon
cd ~
mkdir src
cd src
git clone https://gitlab.com/xboxdrv/xboxdrv.git
cd xboxdrv
git checkout stable
git submodule update --init --recursive
scons
make install