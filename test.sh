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
sudo rm -f /etc/apt/trusted.gpg.d/ansible-ubuntu-ansible.gpg*
# Also try to remove from keyrings directory (newer Ubuntu versions)
sudo rm -f /usr/share/keyrings/ansible-*.gpg

# Update apt cache after removal
echo "=== Updating apt cache ==="
sudo apt-get update

# Run the Ansible playbook
echo "=== Running Ansible playbook ==="
ansible-playbook main.yml -i inventory.ini

echo "=== Test completed successfully ==="
