#!/bin/bash

# Bootstrap Debian with GUI (gnome)

# Update system
sudo apt-get -y update
sudo apt-get -y dist-upgrade

# Practical pkg
sudo apt-get -y install bash-completion vim

# Install xubuntu desktop
sudo apt-get -y install gnome
sudo reboot

