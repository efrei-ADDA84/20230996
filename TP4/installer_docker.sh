#!/bin/bash
# Update the package list
sudo apt-get update
# Install Docker
sudo apt-get install -y docker.io
# Enable Docker to start at boot
sudo systemctl enable --now docker