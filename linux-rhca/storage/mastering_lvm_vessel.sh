#!/bin/bash

# ==============================================================================
# Script: Mastering_LVM_Vessel.sh
# Purpose: RHCSA EX200 Practice - Logical Volume Management (RHEL 9.3)
# Author: Iris | Labs_Wings-Infra-Blueprints
#
# Dedicated to the guardians who keep us grounded while we learn to fly.
# ==============================================================================

echo "--- [ PHASE 1: Physical Volume (PV) ] ---"
# Create Physical Volume on the target device
# Command: sudo pvcreate /dev/nvme0n2 (example device)
echo "Tip: Use 'pvs' to verify existing physical volumes."

echo "--- [ PHASE 2: Volume Group (VG) ] ---"
# Create a Volume Group named 'vg_wings' using the PV
# Command: sudo vgcreate vg_wings /dev/nvme0n2
echo "Tip: Use 'vgs' to check the total free space in the VG."

echo "--- [ PHASE 3: Logical Volume (LV) ] ---"
# Create a 200MB Logical Volume named 'lv_iris'
# Command: sudo lvcreate -n lv_iris -L 200M vg_wings
echo "Tip: Always check if the name matches the exam requirements exactly."

echo "--- [ PHASE 4: File System & Persistence ] ---"
# Format as XFS (RHEL 9 Default) and prepare the mount point
# Command: sudo mkfs.xfs /dev/vg_wings/lv_iris
# Command: sudo mkdir -p /mnt/vessel_data

echo "CRITICAL: Add entry to /etc/fstab for boot persistence:"
echo "/dev/mapper/vg_wings-lv_iris  /mnt/vessel_data  xfs  defaults  0 0"

# Verify the final structure
echo "--- Final Storage Report ---"
sudo lvs