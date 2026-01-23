#!/bin/bash
# Description: Initial setup for Iris's RHCSA Lab
# "Preparing the vessel for the trial"

echo "Updating system and installing exam tools..."

# Install essential packages - Repliforce supply
sudo dnf install -y podman vim bash-completion git

# Autofill activated - nervousness contained
echo "source /usr/share/bash-completion/bash_completion" >> ~/.bashrc

# Creating my basic structure before flying
mkdir -p ~/rhcsa_practice/{containers,storage,network}

echo "Lab environment is ready. Stay focused, Iris."