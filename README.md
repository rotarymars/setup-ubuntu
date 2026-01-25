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
