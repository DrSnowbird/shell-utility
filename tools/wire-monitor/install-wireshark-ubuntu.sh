#!/bin/bash -x

# Step 1: Add the stable official PPA. To do this, go to terminal by pressing Ctrl+Alt+T and run:

sudo add-apt-repository ppa:wireshark-dev/stable

# Step 2: Update the repository:

sudo apt-get update -y

# Step 3: Install wireshark 2.0:

sudo apt-get install -y wireshark

# Step 4: Run wireshark:

sudo wireshark

echo "If you get a error couldn't run /usr/bin/dumpcap in child process: Permission Denied. go to the terminal again and run:"

echo "sudo dpkg-reconfigure wireshark-common"

echo "# Say YES to the message box. This adds a wireshark group. Then add user to the group by typing"

echo "sudo adduser $USER wireshark"

echo "# Then restart your machine and open wireshark. It works. Good Luck."
