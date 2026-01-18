#!/bin/bash

set -eu

echo "=== Starting test script ==="
echo "This script will install Ansible, remove PPA, and run the playbook"

# Add Ansible PPA
echo "=== Adding Ansible PPA ==="
sudo add-apt-repository --yes --update ppa:ansible/ansible

# Install Ansible
echo "=== Installing Ansible ==="
sudo apt-get update
sudo apt-get install -y ansible

# Verify Ansible installation
echo "=== Verifying Ansible installation ==="
ansible --version

# Remove Ansible PPA source and GPG key manually
echo "=== Removing Ansible PPA source and GPG key ==="
sudo rm -f /etc/apt/sources.list.d/ansible-ubuntu-ansible-*.list
sudo rm -f /etc/apt/sources.list.d/ansible-ubuntu-ansible-*.sources
sudo rm -f /etc/apt/trusted.gpg.d/ansible-ubuntu-ansible*.gpg
# Also try to remove from keyrings directory (newer Ubuntu versions)
sudo rm -f /usr/share/keyrings/ansible-ubuntu-ansible*.gpg

# Verify PPA removal
echo "=== Verifying PPA removal ==="
if ls /etc/apt/sources.list.d/ansible-ubuntu-ansible-*.list 2>/dev/null || \
   ls /etc/apt/sources.list.d/ansible-ubuntu-ansible-*.sources 2>/dev/null; then
    echo "Warning: Some Ansible PPA source files still exist"
else
    echo "Ansible PPA sources successfully removed"
fi

# Update apt cache after removal
echo "=== Updating apt cache ==="
sudo apt-get update

# Run the Ansible playbook
echo "=== Running Ansible playbook ==="
if ansible-playbook main.yml -i inventory.ini --become; then
    echo "=== Test completed successfully ==="
    exit 0
else
    echo "=== Test failed - playbook execution returned error ==="
    exit 1
fi
