#!/bin/bash

# ==============================================================================
# Script: Secure Vessel Storage Allocation
# Purpose: RHCSA Practice - Managing Permissions and SGID on RHEL 9.3
#
# Dedicated to the unique ones who arrived first and stayed through the storm.
# "# Dedicated to the unique ones who see the world differently."
# ==============================================================================

echo "Initializing secure storage structure..."

# 1. Create lab directory...
LAB_DIR="/opt/wing_storage"
if [ ! -d "$LAB_DIR" ]; then
    sudo mkdir -p "$LAB_DIR"
    echo "Directory $LAB_DIR created."
fi

# 2. Create a group for "Hunters" (Our "users" in the exam)
sudo groupadd -f hunters

# 3. Adjust Property and Special Permissions (SGID)
# SGID (2) ensures that new files inherit the group from the parent directory.
sudo chown :hunters "$LAB_DIR"
sudo chmod 2770 "$LAB_DIR" 

echo "Permissions set: Only owners and 'hunters' group can access."
echo "SGID bit active: All new files will belong to the 'hunters' group."

# 4. Final Check
ls -ld "$LAB_DIR"
echo "Storage vessel is secured. Integrity check: [ OK ]"