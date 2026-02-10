# setup-ubuntu

Automated Ubuntu setup using Ansible and a custom deb package.

## Architecture

Package installation is handled by a custom `.deb` package (`rotarymars-setup-ubuntu`) which separates the setup into two phases:

- **Phase 1 (preinst)**: Installs GPG keys, adds PPA repositories, creates apt source list files, and updates the apt cache.
- **Phase 2 (postinst)**: Installs all apt packages.

The deb package source and build script are located in `deb-package/`.

### Building the deb package

```bash
cd deb-package
bash build.sh
```

This uses `dpkg-deb` to build `rotarymars-setup-ubuntu.deb` from the package source directory.

### Deb package structure

```
deb-package/
├── build.sh                              # Build script (uses dpkg-deb)
├── rotarymars-setup-ubuntu.deb           # Built deb package
└── rotarymars-setup-ubuntu/              # Package source
    ├── DEBIAN/
    │   ├── control                       # Package metadata
    │   ├── preinst                       # Phase 1: sources & keys
    │   └── postinst                      # Phase 2: package installation
    └── etc/apt/sources.list.d/           # Static apt source lists
        ├── google-chrome.list
        ├── discord-javinator9889.list
        └── github-cli.list
```

## Usage

Run the installation script:
```bash
./install.sh
```

Or use Ansible directly:
```bash
ansible-playbook -i inventory.ini main.yml --ask-become-pass
```

### Install only the deb package (without Ansible)

```bash
cd deb-package
bash build.sh
sudo dpkg -i rotarymars-setup-ubuntu.deb
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

Install bambu lab
```bash
flatpak install flathub com.bambulab.BambuStudio
```

Install orca slicer
```
https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/v2.3.1
```

Install platformio
```bash
curl -fsSL -o get-platformio.py https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py
python3 get-platformio.py
```

Install JetBrain IDEs manually
```bash
sudo mv <IDE_FOLDER> /opt/<IDE_NAME>
```

Install DaVinci resolve

https://www.danieltufvesson.com/makeresolvedeb

Currently installed IDE

- CLion at `/opt/clion`
- DataGrip at `/opt/DataGrip`
- dataspell at `/opt/dataspell`
- pycharm at `/opt/pycharm`
- webstorm at `/opt/webstorm`
- IntelliJ IDEA at `/opt/idea`

# On thinkpad
for realtek network cards

for file /etc/modprobe.d/30-rtw89.conf
```
options rtw89pci disable_aspm_l1=y options rtw89pci disable_aspm_l1ss=y
```
