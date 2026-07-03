#!/usr/bin/env bash
# Install Waydroid (Android container) on Ubuntu 24.04 to run
# Minecraft: Education Edition (Android version) on Linux.
#
# Requires a WAYLAND session to display the UI (log out and pick
# "Ubuntu on Wayland" at the login screen before launching the UI).
set -euo pipefail

echo ">> Installing prerequisites"
sudo apt update
sudo apt install -y curl ca-certificates

echo ">> Adding the official Waydroid apt repository"
curl -s https://repo.waydro.id | sudo bash

echo ">> Installing Waydroid"
sudo apt update
sudo apt install -y waydroid

echo ">> Initializing Waydroid with Google Play (GAPPS) image"
echo "   (downloads ~1-2 GB Android system image; this takes a while)"
sudo waydroid init -s GAPPS

echo ">> Enabling the Waydroid container service"
sudo systemctl enable --now waydroid-container

cat <<'EOF'

============================================================
Waydroid installed. Remaining steps are interactive:

1. Switch to a WAYLAND session:
     Log out -> at the login screen click the gear icon ->
     choose "Ubuntu on Wayland" -> log back in.

2. Launch the Android UI:
     waydroid show-full-ui
   (a window with the Android home screen opens)

3. Certify the device with Google (Play Store blocks
   uncertified devices). Get your device ID:
     sudo waydroid shell -- sh -c \
       "sqlite3 /data/data/*/*/gservices.db \
        'select * from main where name = \"android_id\";'"
   Copy the number, then register it at:
     https://www.google.com/android/uncertified

4. Restart the session so certification takes effect:
     waydroid session stop
     # wait ~1-2 minutes, then:
     waydroid show-full-ui

5. In the Android UI: open Google Play, sign in with a
   Google account, then install "Minecraft Education".

6. Launch Minecraft Education and sign in with your
   Microsoft 365 / Office 365 Education account.
============================================================
EOF
