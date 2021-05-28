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

# Ubuntu 20.04 will automatically install PHP v7.4
# We want PHP 8
sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt update

sudo apt install php8.0 php8.0-cli php8.0-fpm php8.0-pdo php8.0-mysql php8.0-zip php8.0-gd php8.0-mbstring php8.0-curl php8.0-xml php8.0-bcmath
echo "PHP version installed:"
php --version
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/8.0/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/8.0/fpm/php.ini

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
sudo apt-get install -y supervisor

# acl to handle permissions
sudo apt-get install -y acl


# Node.js
echo "Installing Node.js..."
curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt install nodejs
echo "Installed Node version:"
node -v

echo "Adding some artisan conveniences..."
echo "alias a='php artisan '" >> ~/.bashaliases
echo "alias art='php artisan '" >> ~/.bashaliases
source ~/.bashaliases

echo "Done! 💪"
echo "You can now proceed to setup your project."
