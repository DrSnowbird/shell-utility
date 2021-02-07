#!/bin/bash -x

# -- usage --
# Search and open 'Youtube to MP3' via dash or another launcher. 
# Copy the Youtube video URL from the browser to your clipboard and 
# paste it into the application by clicking the 'Paste link' button 
# on the top-left corner. See screenshot below.
#
# The download and conversion will begin automatically and 
# the audio saved in the Home folder under /Music/Downloaded by MediaHuman

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7D19F1F3
sudo add-apt-repository https://www.mediahuman.com/packages/ubuntu

sudo apt update
sudo apt install youtube-to-mp3
