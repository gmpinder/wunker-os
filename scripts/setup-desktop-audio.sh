#!/usr/bin/env bash
set -euo pipefail

echo "# This file was added by the program 'hda-jack-retask'.
# If you want to revert the changes made by this program, you can simply erase this file and reboot your computer.
options snd-hda-intel patch=hda-jack-retask.fw,hda-jack-retask.fw,hda-jack-retask.fw,hda-jack-retask.fw" > /etc/modprobe.d/hda-jack-retask.conf

echo "[codec]
0x10ec0b00 0x10438797 0

[pincfg]
0x11 0x411111f0
0x14 0x01014010
0x15 0x01011012
0x16 0x01016011
0x17 0x40170000
0x18 0x01a19050
0x19 0x02a19060
0x1a 0x0181305f
0x1b 0x01014010
0x1e 0x01456140" > /lib/firmware/hda-jack-retask.fw