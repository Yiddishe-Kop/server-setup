#!/bin/bash

# Initial User setup & Firewall

# Update
sudo apt-get update

# Install cURL & ZIP/UNZIP
sudo apt-get install -y curl zip unzip

# setup sudo user (non-root)
echo "Choose your username"
read username
sudo adduser $username
sudo usermod -aG sudo $username
echo "Created account for $username..."

# Check Firewall Configurations
echo "Your firewall configuration is:"
sudo ufw app list
sudo ufw allow OpenSSH
sudo ufw enable
echo "Your new firewall configuration is:"
sudo ufw status
echo "Copying SSH keys to user $username..."
sudo rsync --archive --chown=$username:$username ~/.ssh /home/$username

echo "Done! 💪"
echo "==================================================="
echo "You can now log back in with your new user like so:"
echo "ssh $username@$(curl -4s icanhazip.com)"
echo "==================================================="
