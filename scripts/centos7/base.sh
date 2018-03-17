#!/bin/bash

set -e
set -x

# Packages
sudo yum install -y unzip tmux bzip2

# Users
sudo useradd -m -p $(echo daniel | openssl passwd -1 -stdin) daniel
sudo useradd -m -p $(echo christine | openssl passwd -1 -stdin) christine
sudo useradd -m -p $(echo kris | openssl passwd -1 -stdin) kris
sudo useradd -m -p $(echo ben | openssl passwd -1 -stdin) ben

sudo usermod -aG wheel daniel
sudo usermod -aG wheel christine
sudo usermod -aG wheel kris
sudo usermod -aG wheel ben
