#!/bin/bash

sudo apt update
sudo apt upgrade -y
sudo apt install virtualbox -y
wget https://releases.hashicorp.com/vagrant/2.2.9/vagrant_2.2.9_x86_64.deb
sudo apt install ./vagrant_2.2.9_x86_64.deb -y
vagrant --version 
