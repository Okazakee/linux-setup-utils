#!/bin/bash

# Variables
EMAIL="okazakee@proton.me"
KEYS_DIR="$HOME/.ssh"

# List of services
declare -a services=("github" "gitlab" "bitbucket" "azure" "rpi-web" "fedora")

# Generate SSH keys
for service in "${services[@]}"; do
    KEY_NAME="${KEYS_DIR}/${service}_id_rsa"
    echo "Generating SSH key for $service..."
    ssh-keygen -t rsa -b 4096 -C "$EMAIL" -f "$KEY_NAME" -N ""
done

# Start the SSH agent
eval "$(ssh-agent -s)"

# Add keys to the SSH agent
for service in "${services[@]}"; do
    KEY_NAME="${KEYS_DIR}/${service}_id_rsa"
    echo "Adding $service SSH key to the SSH agent..."
    ssh-add "$KEY_NAME"
done

echo "SSH keys for GitHub, GitLab, Bitbucket, Azure, RPi-Web, and Fedora PC generated and added to the SSH agent."


# Create SSH config file
SSH_CONFIG_FILE="$KEYS_DIR/config"

echo "Creating SSH config file..."

cat <<EOL > $SSH_CONFIG_FILE
# SSH configuration for GitHub
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_id_rsa

# SSH configuration for GitLab
Host gitlab.com
    HostName gitlab.com
    User git
    IdentityFile ~/.ssh/gitlab_id_rsa

# SSH configuration for Bitbucket
Host bitbucket.org
    HostName bitbucket.org
    User git
    IdentityFile ~/.ssh/bitbucket_id_rsa

# SSH configuration for Azure
Host azure
    HostName azure.com
    User your-azure-username
    IdentityFile ~/.ssh/azure_id_rsa

# SSH configuration for Raspberry Pi Web
Host rpi
    HostName rpi.local
    User pi
    IdentityFile ~/.ssh/rpi_id_rsa

# SSH configuration for Fedora
Host fedora
    HostName fedora.local
    User your-fedora-username
    IdentityFile ~/.ssh/fedora_id_rsa
EOL

# Set correct permissions for the config file
chmod 700 ~/.ssh
chmod 600 $SSH_CONFIG_FILE

echo "SSH config file created and permissions set."
