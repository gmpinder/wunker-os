#!/usr/bin/env bash

# Fail on any error
set -eou pipefail

# Define version
version="v3.0.72.1-rc1"

# Define base name for the file
base_name="synergy-linux_x64-libssl3"

# Define file URL
url="https://rc.symless.com/synergy3/${version}/${base_name}-${version}.flatpak"

# Define file name
file="/tmp/${base_name}-${version}.flatpak"

# Download file
echo "Downloading file..."
wget -O "$file" "$url"

# Install the package
echo "Installing package..."
flatpak install -y "$file"

# Remove the downloaded file
echo "Removing the downloaded file..."
rm "$file"

echo "Done."
