#!/bin/bash
#
# EX200 - Root Password Reset (Rescue Mode)
# This script is intended as a guided checklist for exam practice.
# Do NOT run blindly on production systems (Your vessel might broken).
#

echo "=== EX200 | Root Password Reset - Rescue Mode ==="
echo
echo "This script assumes you are already booted with 'rd.break'"
echo "and currently at the emergency shell."
echo

echo "[1/6] Remounting /sysroot as read-write..."
mount | grep sysroot
mount -o remount,rw /sysroot || {
  echo "Failed to remount /sysroot"
  exit 1
}

echo "[2/6] Entering chroot environment..."
chroot /sysroot || {
  echo "Failed to chroot into /sysroot"
  exit 1
}

echo "[3/6] Resetting root password..."
echo "You will be prompted to set a new root password."
passwd root || {
  echo "Password change failed"
  exit 1
}

echo "[4/6] Enabling SELinux relabel on next boot..."
touch /.autorelabel

echo "[5/6] Exiting chroot..."
exit

echo "[6/6] Exiting emergency shell."
echo "Press Ctrl+D again to reboot the system."
echo
echo "NOTE: SELinux relabeling may take several minutes."
