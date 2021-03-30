#!/bin/bash -x

# 1. Unplug Webcam
    ll /dev/video*
    ll /dev/audio*

# 2. Plugin Webcam
    ll /dev/video*
    ll /dev/audio*
you should see your webcam list above

# 3. connection setup to Webcam
Need to setup vlc:cammer to :camera
    snap connect vlc:camera :camera

Next, show connections to vlc
    snap connections vlc
(base) user1@user1-desktop:~$ /usr/bin/vlc v4l2:///dev/video0
VLC media player 3.0.9.2 Vetinari (revision 3.0.9.2-0-gd4c1aefe4d)

# 4. Launch VLC GUI with connection to /dev/video0
vlc v4l2:///dev/video0

