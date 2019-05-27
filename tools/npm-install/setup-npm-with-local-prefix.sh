# NPM Setup (avoid Global with Sudo!!)

# ref: https://medium.com/@ExplosionPills/dont-use-sudo-with-npm-still-66e609f5f92

echo "1.) Install NPM package ..."
sudo apt install npm

echo "2.) Setup prefix for global installs ..."
mkdir ~/.npm
sudo chown -R $(whoami) ~/.npm
npm config set prefix ~/.npm

echo "3.) Setup PATH to use ~/.npm ..."
export PATH="$HOME/.npm/bin:$PATH"
if [ -x ~/.bashrc ]; then
    echo "export PATH=\$HOME/.npm/bin:\$PATH" >> ~/.bashrc
else
    echo " not found!"
fi

if [ -x ~/.bash_profile ]; then
    echo "export PATH=\$HOME/.npm/bin:\$PATH" >> ~/.bash_profile
else
    echo " not found!"
fi

sudo chown -R $(whoami) ~/.npm
npm install -g npm
export PATH="$HOME/.npm/bin:$PATH"

