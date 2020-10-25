#!/bin/bash

# Laravel Setup

sudo apt update

# NGINX
echo "Installing NGINX..."
sudo apt install nginx

echo "Your firewall configuration is:"
sudo ufw app list
sudo ufw allow 'Nginx Full'
echo "Your new firewall configuration is:"
sudo ufw status
echo "You can now visit $(curl -4s icanhazip.com) to see the server running! 💡"

# MySQL
echo "Installing MySQL..."
sudo apt install mysql-server
sudo mysql_secure_installation

# PHP
echo "Installing PHP..."
sudo apt update
# Ubuntu 20.04 will automatically install PHP v7.4
sudo apt install php php-cli php-fpm php-json php-pdo php-mysql php-zip php-gd php-mbstring php-curl php-xml php-bcmath
echo "PHP version installed:"
php --version

# Composer
echo "Installing Composer..."
sudo apt update
sudo apt install unzip
cd ~
curl -sS https://getcomposer.org/installer -o composer-setup.php
HASH=`curl -sS https://composer.github.io/installer.sig`
php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# supervisor
sudo apt-get install supervisor

# Node.js
echo "Installing Node.js..."
curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt install nodejs
echo "Installed Node version:"
node -v

echo "Adding some artisan conveniences..."
echo "alias a='php artisan '" >> ~/.bash_aliases
echo "alias art='php artisan '" >> ~/.bash_aliases
source ~/.bash_aliases

echo "Done! 💪"
echo "You can now proceed to setup your project."
