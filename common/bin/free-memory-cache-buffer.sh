#!/bin/bash -x

# ref: https://unix.stackexchange.com/questions/87908/how-do-you-empty-the-buffers-and-cache-on-a-linux-system

sudo sh -c 'echo 1 >/proc/sys/vm/drop_caches'
sudo sh -c 'echo 2 >/proc/sys/vm/drop_caches'
sudo sh -c 'echo 3 >/proc/sys/vm/drop_caches'

sudo sh -c 'free && sync && echo 3 > /proc/sys/vm/drop_caches && free'

echo "You can also run command to see memory info: cat /proc/meminfo"
