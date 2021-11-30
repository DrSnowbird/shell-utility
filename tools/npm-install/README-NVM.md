# Source & Credits:
* https://tecadmin.net/how-to-install-nvm-on-ubuntu-20-04/

# Prerequisites
* You must have a running Ubuntu 20.04 Linux system with shell access.
Log in with a user account to which you need to install node.js.
Installing NVM on Ubuntu
* A shell script is available for the installation of nvm on the Ubuntu 20.04 Linux system. Open a terminal on your system or connect a remote system using SSH. Use the following commands to install curl on your system, then run the nvm installer script.
    ```
    sudo apt install curl
    curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 
    ```
* The nvm installer script creates environment entry to login script of the current user. You can either logout and login again to load the environment or execute the below command to do the same.
    ```
    source ~/.profile
    ```

# Installing Node using NVM
* You can install multiple node.js versions using nvm. And use the required version for your application from installed node.js.

* Install the latest version of node.js. Here node is the alias for the latest version.
    ```
    nvm install node
    ```
# To install a specific version of node:
* You can use the following command to list installed versions of node for the current user.
    ```
    nvm install 12.18.3
    ```

* You can choose any other version to install using the above command. The very first version installed becomes the default. New shells will start with the default version of node (e.g., nvm alias default).

# Working with NVM
* You can use the following command to list installed versions of node for the current user.
    ```
    nvm ls
    ```
* With this command, you can find the available node.js version for the installation.
    ```
    nvm ls-remote
    ```
* You can also select a different version for the current session. The selected version will be the currently active version for the current shell only.
    ```
    nvm use 12.18.3
    ```
* To find the default Node version set for the current user, type:
    ```
    nvm run default --version
    ```
* You can run a Node script with the desired version of node.js using the below command:
    ```
    nvm exec 12.18.3 server.js
    ```

