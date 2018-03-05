#!/bin/bash

# Bootstrap debian with Syncthing (CLI)

# Update system
sudo apt-get -y update
sudo apt-get -y dist-upgrade

# Practical pkg
sudo apt-get -y install bash-completion vim
# Set editor
sudo update-alternatives --set editor /usr/bin/vim.basic

## Install Syncthing
# Setup repository (we need 'apt-transport-https')
sudo apt-get install apt-transport-https
# Add the release PGP keys:
curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
# Add the "stable" channel to your APT sources:
echo "deb https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
# Update and install syncthing:
sudo apt-get update
sudo apt-get install syncthing
# Setup systemd service as user (on login)
mkdir -p ~/.config/systemd/user/
curl https://raw.githubusercontent.com/syncthing/syncthing/master/etc/linux-systemd/user/syncthing.service -o  ~/.config/systemd/user/syncthing.service

#Enable and start the service:
systemctl --user enable syncthing.service
systemctl --user start syncthing.service
sleep 20

# Configure Syncthing webGUI to listen on all IP (insecure)
sed -i 's/127.0.0.1/0.0.0.0/' ~/.config/syncthing/config.xml

# Create some folders to test
mkdir ~/documents ~/videos ~/pictures ~/notes
# Create web folder with synlink to folder
mkdir ~/web/ 
cd ~/web/ && ln -s -t . ~/documents ~/videos ~/pictures ~/notes
# Copy
curl https://gist.githubusercontent.com/UniIsland/3346170/raw/059aca1d510c615df3d9fedafabac4d538ebe352/SimpleHTTPServerWithUpload.py -o SimpleHTTPServerWithUpload.py
chmod +x SimpleHTTPServerWithUpload.py

# Reboot
sudo reboot

