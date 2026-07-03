#!/usr/bin/env bash
# Install Wine (WineHQ stable) on Ubuntu 24.04 (noble).
# Mirrors the ansible apt role: same key path + a one-line deb source with an
# explicit signed-by. This is the repo the playbook was missing.
set -euo pipefail

KEYFILE=/usr/share/keyrings/winehq-archive.asc
LISTFILE=/etc/apt/sources.list.d/winehq.list
CODENAME="$(. /etc/os-release && echo "$VERSION_CODENAME")"   # e.g. noble
BRANCH="${1:-stable}"                                          # stable | staging | devel

echo ">> Enabling i386 architecture (needed for 32-bit Windows apps)"
sudo dpkg --add-architecture i386

echo ">> Installing WineHQ signing key -> $KEYFILE"
sudo mkdir -pm755 /usr/share/keyrings
sudo wget -q -O "$KEYFILE" https://dl.winehq.org/wine-builds/winehq.key

echo ">> Removing any stale winehq .sources file"
sudo rm -f /etc/apt/sources.list.d/winehq-"${CODENAME}".sources

echo ">> Adding WineHQ apt source -> $LISTFILE"
echo "deb [arch=amd64,i386 signed-by=$KEYFILE] https://dl.winehq.org/wine-builds/ubuntu ${CODENAME} main" \
  | sudo tee "$LISTFILE" >/dev/null

echo ">> Updating apt and installing winehq-${BRANCH}"
sudo apt update
sudo apt install -y --install-recommends "winehq-${BRANCH}"

echo ">> Done. Installed: $(wine --version)"
