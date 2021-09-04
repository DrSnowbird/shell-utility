#!/bin/bash -x

#### ---- fixed Ubuntu not displaying 'thumbnail' png files ---- ####
#### ref: https://askubuntu.com/questions/1034595/thumbnails-not-showing-in-video-in-ubuntu-18-04
echo "sudo apt install ffmpegthumbnailer -y"
echo
echo "Most likely, you can do this cmd to clean .cache and it should be enough!"
echo "Alternatively you can run- rm -rf ~/.cache/thumbnails/* in Terminal to clear the thumbnail cache. "
echo
