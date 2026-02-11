#!/bin/bash

# ==============================================================================
# Script: vessel_health_monitor.sh
# Purpose: Real-time Health Check for Mission-Critical Java Applications
# ==============================================================================

THRESHOLD_CPU=80
THRESHOLD_DISK=90

echo "--- Starting System Health Audit ---"

# 1. Check CPU Load
CPU_LOAD=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
echo "Current CPU Load: $CPU_LOAD%"
if (( $(echo "$CPU_LOAD > $THRESHOLD_CPU" | bc -l) )); then
    echo "[ALERT] High CPU usage detected!"
fi

# 2. Check Disk Space (Root Partition)
DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
echo "Disk Usage: $DISK_USAGE%"
if [ "$DISK_USAGE" -gt "$THRESHOLD_DISK" ]; then
    echo "[ALERT] Critical Disk Space: Clear logs immediately!"
fi

# 3. Check if Java Application is Running
# This mimics checking for a specific service like a Radar Monitor
JAVA_PROCESS=$(pgrep -f java)
if [ -z "$JAVA_PROCESS" ]; then
    echo "[CRITICAL] Java Process NOT FOUND! Attempting to notify SRE team..."
else
    echo "[OK] Java Process is running on PID: $JAVA_PROCESS"
fi

echo "--- Audit Complete ---"