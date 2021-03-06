# Server setup scripts

I was tired spending hours setting up each new server for Laravel projects.
So this time I decided to write all the commands in a script, which I can run with ease.

The scripts are devided into 3 parts:
### 1. Initial user setup & Firewall
Creates a non-root user (prompts for username), with `sudo` priveleges.
Enables the `ufw` firewall.
It outputs the ssh command for you to log back in with your newly created account:

```bash
"Done! 💪
===================================================
You can now log back in with your new user like so:
ssh $username@$ip_address
==================================================="
```

### 2. Installing deendancies for Laravel

Installs:
- NGINX
- MySQL
- PHP (8.0 on Ubuntu 20.04+)
- Composer
- Node.js (NPM inc.)

This also adds artisan aliases, so you can run artisan commands with `a` or `art` 👌 .

### Project Setup
Sets up your project to be up and running:
- MySQL database & user for you project
- Git repo for continuous deployment - see [my article](https://blog.yiddishe-kop.com/posts/setting-up-a-fresh-server-for-continuous-deployment-with-git) how it works
- Configures NGINX
- Creates SSL certificate & redirect HTTP to HTTPS
- propmpts you to push your code to the server:
```bash
"Now run the following command from your local project folder:
git remote add <remote-name> ssh://<user>@<ip>/home/<user>/repo/<project-name>.git
Then you can push to deploy like so:
git push <remote-name>
Press enter once code is pushed to server..."
```
> variable names are subsituted with real values by the script 👍
- Creates `.env` with correct DB credentials
- Runs artisan setup commands
- Builds assets with `npm run build`
- Runs your migrations
- Sends a Slack notification once done (can be edited in `post-receive`) (optional - not included rn)

# Usage
1. SSH into your fresh Ubuntu machine
2. clone this repo
3. run `./1-initial-user-firewall-setup.sh`
4. Follow the instructions - exit the server & log back in with the given credentials.
5. clone this repo into your new users home directory.
6. Run `./2-ubuntu-laravel-setup.sh` to install Laravel dependencies.
7. Run `./3-project-setuo-and-cd.sh` to setup your project.
8. Done. Your Laravel app is now live. Happy coding 🥳 .


#### Credit
This detailed tutorial by [DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-laravel-with-nginx-on-ubuntu-20-04) has made this possible 😃 .
