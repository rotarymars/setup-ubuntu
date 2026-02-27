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

# On thinkpad
for realtek network cards

for file /etc/modprobe.d/30-rtw89.conf
```
options rtw89pci disable_aspm_l1=y options rtw89pci disable_aspm_l1ss=y
```
