#!/bin/bash -x

ON_OFF=${1:-"true"}
gsettings set org.gnome.nautilus.preferences always-use-location-entry ${ON_OFF}
