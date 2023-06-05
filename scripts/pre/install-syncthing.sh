#!/usr/bin/env bash
set -oue pipefail

VERSION="v1.23.4"
BASE_URL="https://github.com/syncthing/syncthing/releases/download"
FILENAME="syncthing-linux-amd64-${VERSION}.tar.gz"
EXTRACTED_DIR="syncthing-linux-amd64-${VERSION}"

# Download the file
wget --quiet "${BASE_URL}/${VERSION}/${FILENAME}"

# Extract the file
tar xf "${FILENAME}"

# Move the binary to /usr/local/bin
mv "${EXTRACTED_DIR}/syncthing" /usr/bin

# Move .desktop files
mv "${EXTRACTED_DIR}/etc/linux-desktop/"*.desktop /usr/share/applications/

# Move the systemd service file
cp "${EXTRACTED_DIR}/etc/linux-systemd/user/syncthing.service" /etc/systemd/system/

# Enable the systemd service
systemctl enable syncthing

# Verify the installation
if command -v syncthing &> /dev/null
then
    echo "Syncthing command is found in PATH."
else
    echo "Syncthing command not found in PATH."
    exit 1
fi

# Verify that syncthing --version works
if syncthing --version &> /dev/null
then
    echo "Syncthing --version executes successfully."
else
    echo "Syncthing --version did not execute successfully."
    exit 1
fi

# Cleanup
rm -rf "${EXTRACTED_DIR}"
