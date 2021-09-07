#!/bin/bash -x

function setup_GTK_Missing_Lib() {
    sudo apt-get install -y libcanberra-gtk-module 

    if [ "`cat $HOME/.bashrc | grep -i GTK_PATH`" = "" ]; then
        cat >> ~/.bashrc << EOF

#### ---- GTK Lib setup: ---- ####
export GTK_PATH=/usr/lib/x86_64-linux-gnu/gtk-3.0

EOF
    else
	echo "..... setup_GTK_Missing_Lib(): already being set up!"
    fi
}

setup_GTK_Missing_Lib
