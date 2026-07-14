# setup-ubuntu

Automated Ubuntu setup using Ansible.

## Usage

Run the installation script:
```bash
./install.sh
```

Or use Ansible directly:
```bash
ansible-playbook -i inventory.ini main.yml --ask-become-pass
```

## Post-Installation Manual Steps
Instsall vscode manually

Install fzf
```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### Configure ibus-mozc as default input method
```bash
im-config -n ibus
```

### Disable KVM for VirtualBox (if needed)
```bash
echo "blacklist kvm"       | sudo tee /etc/modprobe.d/blacklist-kvm.conf
echo "blacklist kvm_intel" | sudo tee -a /etc/modprobe.d/blacklist-kvm.conf
sudo update-initramfs -u
```
Install copilot cli
```
curl -fsSL https://gh.io/copilot-install | bash
```

Install orca slicer
```
https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/v2.3.1

flatpak install --user ./file.flatpak
```

Install Chitubox

Download the Linux x64 `.tar.gz` (needs a free account) from
https://www.chitubox.com/en/download/chitubox-free
```bash
# Qt runtime deps
sudo apt install libxcb-xinerama0 libxcb-cursor0 libgl1

tar -xzf CHITUBOX_Basic_x64_V*.tar.gz
# run the bundled installer, then launch from the install dir:
#   right-click CHITUBOX_Basic.sh -> "Run as a Program" (or ./CHITUBOX_Basic.sh)
```

Install platformio
```bash
curl -fsSL -o get-platformio.py https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py
python3 get-platformio.py
```

Freeze kernel at generic
```bash
sudo apt-mark hold linux-image-generic-hwe-24.04 linux-headers-generic-hwe-24.04
```
Execute below:

```bash
sudo rm /etc/apt/sources.list.d/google-chrome.list
```

Install antigravity
```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | \
  sudo gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" | \
  sudo tee /etc/apt/sources.list.d/antigravity.list > /dev/null
sudo apt update && sudo apt install antigravity
```

Install stuff from rustup
```bash
rustup default stable
```

Install jj
```bash
cargo install --locked --bin jj jj-cli
```

Install claude code
```bash
curl -fsSL https://claude.ai/install.sh | bash
```

Install ollama
```bash
curl -fsSL https://ollama.com/install.sh | sh
```

Install proton
https://protonvpn.com/ja/support/official-linux-vpn-ubuntu
```
wget https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.8_all.deb
sudo dpkg -i ./protonvpn-stable-release_1.0.8_all.deb && sudo apt update
sudo apt install proton-vpn-gnome-desktop
sudo apt install gnome-shell-extension-appindicator
```

Install act
```bash
gh extension install https://github.com/nektos/gh-act
```

Install gemini-cli and stuff
```bash
npm install -g  @google/gemini-cli
gemini mcp add -s user chrome-devtools npx chrome-devtools-mcp@latest
```

Install coderabbit cli
```bash
curl -fsSL https://cli.coderabbit.ai/install.sh | sh
```

Install openclaw
```bash
curl -fsSL https://openclaw.ai/install.sh | bash
```

Install Minecraft: Education Edition via Waydroid

There is no native Linux build, so run the Android version inside Waydroid.
Ansible installs the `waydroid` package; the steps below are one-time and interactive.
```bash
# 1. Initialize with Google Play (downloads ~1-2 GB Android image) and start the service
sudo waydroid init -s GAPPS
sudo systemctl enable --now waydroid-container

# 2. Switch to a Wayland session: log out -> gear icon -> "Ubuntu on Wayland" -> log back in

# 3. Launch the Android UI
waydroid show-full-ui

# 4. Certify the device with Google (Play Store blocks uncertified devices)
sudo waydroid shell -- sh -c "sqlite3 /data/data/*/*/gservices.db 'select * from main where name = \"android_id\";'"
# Register the printed number at https://www.google.com/android/uncertified

# 5. Restart the session so certification takes effect
waydroid session stop   # wait 1-2 min, then:
waydroid show-full-ui

# 6. In the UI: sign into Google Play, install "Minecraft Education",
#    then launch it and sign in with a Microsoft 365 Education account.
```

# On thinkpad
for realtek network cards

for file /etc/modprobe.d/30-rtw89.conf
```
options rtw89pci disable_aspm_l1=y options rtw89pci disable_aspm_l1ss=y
```
