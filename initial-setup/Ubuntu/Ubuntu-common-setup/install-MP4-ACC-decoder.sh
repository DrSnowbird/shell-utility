#!/bin/bash -x

sudo apt-get install -y ubuntu-restricted-extras

# Ubuntu 20.04
sudo apt-get install -y libavcodec58 ffmpeg gstreamer1.0-libav

# bug remove: 4
# Beware of the audio-only gstreamer bu
rm -R ~/.cache/gstreamer-1.0
