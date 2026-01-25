#!/bin/bash

set -eu

# Install Ansible if not already installed
if ! command -v ansible &> /dev/null; then
    echo "Installing Ansible..."
    sudo apt update
    sudo apt install -y software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install -y ansible
fi

# Run the Ansible playbook
echo "Running Ansible playbook..."
ansible-playbook -i inventory.ini main.yml --ask-become-pass

echo "Installation complete!"
echo ""
echo "Please review README.md for any manual post-installation steps."
