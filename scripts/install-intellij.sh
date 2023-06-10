#!/usr/bin/env bash
set -eou pipefail

# Version number
VERSION=$(curl -s "https://blog.jetbrains.com/idea/" | grep -oP 'IntelliJ IDEA \K[0-9]+\.[0-9]+\.[0-9]*' | head -1)

# Download https://download.jetbrains.com/idea/ideaIC-${VERSION}.tar.gz
curl -L -o /tmp/ideaIC-${VERSION}.tar.gz https://download.jetbrains.com/idea/ideaIC-${VERSION}.tar.gz

# Extract to /usr/opt
mkdir -p /usr/opt
tar -xzf /tmp/ideaIC-${VERSION}.tar.gz -C /usr/opt

# Find the full path to the IntelliJ directory
IDEA_PATH=$(ls -d /usr/opt/idea-IC-*)

# Create .desktop file
cat > /tmp/intellij.desktop <<EOL
[Desktop Entry]
Version=1.0
Type=Application
Name=IntelliJ IDEA Community Edition
Icon=$IDEA_PATH/bin/idea.png
Exec="$IDEA_PATH/bin/idea.sh" %f
Terminal=false
Categories=Development;IDE;
EOL

# Make the application available to all users
sudo mv /tmp/intellij.desktop /usr/share/applications/
