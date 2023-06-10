#!/usr/bin/env bash
set -eou pipefail

# Version number
VERSION="2023.1.2"

# Download https://download.jetbrains.com/ruby/RubyMine-2023.1.2.tar.gz
curl -L -o /tmp/RubyMine-${VERSION}.tar.gz https://download.jetbrains.com/ruby/RubyMine-${VERSION}.tar.gz

# Extract to /usr/opt
mkdir -p /usr/opt
tar -xzf /tmp/RubyMine-${VERSION}.tar.gz -C /usr/opt

# Find the full path to the RubyMine directory
RUBYMINE_PATH=$(ls -d /usr/opt/RubyMine-*)

# Create .desktop file
cat > /tmp/rubymine.desktop <<EOL
[Desktop Entry]
Version=1.0
Type=Application
Name=RubyMine
Icon=$RUBYMINE_PATH/bin/rubymine.png
Exec="$RUBYMINE_PATH/bin/rubymine.sh" %f
Terminal=false
Categories=Development;IDE;
EOL

# Make the application available to all users
sudo mv /tmp/rubymine.desktop /usr/share/applications/