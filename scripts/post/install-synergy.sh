#!/usr/bin/env bash

# Fail on any error
set -eou pipefail

# Define version
version="v3.0.72.1-rc1"

# Define base name for the file
base_name="synergy-linux_x64-libssl3"

# Define file URL
url="https://rc.symless.com/synergy3/${version}/${base_name}-${version}.rpm"

# Define file name
file="/tmp/${base_name}-${version}.rpm"

# Directory that we need to remove before installation
dir="/opt/Synergy"

# Download file
echo "Downloading file..."
wget -Oq "$file" "$url"

# Check if directory exists
if [ -d "$dir" ]
then
    echo "Removing existing directory..."
    rm -rf "$dir"
fi

# Install the package using rpm
echo "Installing package..."
rpm -i "$file"

# Remove the downloaded file
echo "Removing the downloaded file..."
rm "$file"

echo "Done."
