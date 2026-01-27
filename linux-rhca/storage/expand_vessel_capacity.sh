#!/bin/bash
# ==============================================================================
# Script: expand_vessel_capacity.sh
# Purpose: RHCSA Practice - Extending Logical Volumes and Resizing Filesystems
#
# "They may try to limit your space, but you have the power to expand."
# Dedicated to the resilience of the unique ones.
# ==============================================================================

echo "Checking current storage capacity..."
sudo lvs

# Step 1: Add more space to the Volume Group (if needed)
# Command: sudo vgextend vg_wings /dev/sdX

# Step 2: Extend the Logical Volume by 500MB
# The -r flag resizes the underlying filesystem automatically (very useful for the exam!)
echo "Extending logical volume lv_iris..."
# sudo lvextend -L +500M -r /dev/vg_wings/lv_iris

echo "Verification: New size for lv_iris:"
# sudo lvs /dev/vg_wings/lv_iris

echo "Capacity expanded. The vessel is now stronger."