#!/bin/bash
#
# EX200 - Root Password Reset (Single User Mode)
# Boot parameters required:
#   - replace ro with rw
#   - append init=/bin/bash
#

echo "=== EX200 | Root Password Reset - Single User Mode ==="
echo
echo "This script assumes you booted with:"
echo "  init=/bin/bash rw"
echo

echo "[1/4] Resetting root password..."
passwd root || {
  echo "Password change failed"
  exit 1
}

echo "[2/4] Enabling SELinux relabel..."
touch /.autorelabel

echo "[3/4] Syncing filesystem..."
sync

echo "[4/4] Rebooting system..."
exec /sbin/init