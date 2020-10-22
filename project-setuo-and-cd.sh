#!/bin/bash

# highlight colors
RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color


printf "${CYAN}What is your project name (no dashes allowed)?${NC}\n"
read projectName

printf "${PURPLE}What a nice project! $projectName!${NC}\n"

# Setup DB
printf "${GREEN}Setting up MySql Database...${NC}\n"
printf "${RED}Enter sudo password:${NC}\n"
read sudoPassword
printf "${RED}Enter the DB password:${NC}\n"
read dbPassword

sudo mysql -u root -p$sudoPassword -Bse "
  CREATE DATABASE $projectName;
  CREATE USER '${projectName}_user'@'%' IDENTIFIED WITH mysql_native_password BY '$dbPassword;
  GRANT ALL ON $projectName.* TO '${projectName}_user'@'%';
"
printf "${GREEN}Created Database 🥳${NC}\n"
printf "${GREEN}Database credentials:${NC}\n"
printf "${CYAN}Database Name: ${GREEN}${projectName}\n"
printf "${CYAN}DB Username: ${GREEN}${projectName}_user\n"
printf "${CYAN}DB Password: ${GREEN}${dbPassword}\n"

# Setup Git
mkdir -p /var/www/$projectName
mkdir -p ~/repo/$projectName.git
cd ~/repo/$projectName.git
git init --bare
IP="$(curl -4s icanhazip.com)"
cat post-receive | sed "s/PROJECT_NAME/$projectName/" | sed "s/IP_ADDRESS/$IP/" > hooks/post-receive
chmod +x hooks/post-receive
printf "${GREEN}Finished setting up Git & CD! 🥳${NC}\n"

# permissions
sudo gpasswd -a "$USER" www-data
sudo chown -R "$USER":www-data /var/www

printf "${CYAN}What is your projects domain?${NC}\n"
read domainName

# Configure nginx
sudo cat nginx.conf | sed "s/PROJECT_NAME/$projectName/" | sed "s/DOMAIN_NAME/$domainName/" > /etc/nginx/sites-available/$projectName
sudo ln -s /etc/nginx/sites-available/$projectName /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
printf "${GREEN}Finished setting up your NGINX configuration! 🥳${NC}\n"
printf "${GREEN}Configured domain is: $domainName ${NC}\n"

# SSL
printf "${GREEN}Setting up SSL...${NC}\n"
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx
printf "${GREEN}SSL ready!${NC}\n"

printf "${PURPLE}Now run the following command from your local project folder:${NC}\n"
printf "${CYAN}git remote add <remote-name> ssh://$USER@$IP/home/$USER/repo/$projectName.git${NC}\n"
printf "${GREEN}Then you can push to deploy like so:{NC}\n"
printf "${CYAN}git push <remote-name>\n"
read -p "Press enter once code is pushed to server..."

cd /var/www/$projectName
cat .env.example | sed "s/DB_DATABASE=laravel/DB_DATABASE=$projectName/" | sed "s/DB_USERNAME=root/DB_USERNAME=${projectName}_user/" | sed "s/DB_PASSWORD=/DB_PASSWORD=${dbPassword}/" > .env
php artisan key:generate
php artisan storage:link

echo "Running NPM build command"
npm install
npm run build

echo "running composer install"
composer install --no-interaction --no-dev --prefer-dist

echo "running migrations"
php artisan migrate --force

SLACK_POST_URL="https://hooks.slack.com/services/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"
curl -X POST --data-urlencode "payload={'channel': '#deployments', 'username': 'yiddishe-bot', 'text': 'Successfully setup <https://$domainName/|$projectName> for the first time!', 'icon_emoji': ':yiddishe-kop:'}" $SLACK_POST_URL

printf "${PURPLE}======================${NC}\n"
printf "${GREEN}All done! 🥳${NC}\n"
printf "${GREEN}Happy coding ⌨️${NC}\n"
printf "${PURPLE}======================${NC}\n"
