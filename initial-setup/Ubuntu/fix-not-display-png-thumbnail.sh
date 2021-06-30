#!/bin/bash -x

#### ---- fixed Ubuntu not displaying 'thumbnail' png files ---- ####
sudo apt install ffmpegthumbnailer -y
echo
echo "or, you can do this cmd to clean .cache"
echo "Alternatively you can run- rm -rf ~/.cache/thumbnails/* in Terminal to clear the thumbnail cache. "
echo
