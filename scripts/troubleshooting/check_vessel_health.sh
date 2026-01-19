#!/bin/bash

# ==========================================================
# Script: Vessel Health Check (Container Monitoring)
# Purpose: RHCSA Lab - Ensure container engine is active
# ==========================================================

echo "Starting system diagnostic..."

# 1. Verify if podman is running...
if systemctl is-active --quiet podman; then
    echo "Checking Engine... [ OK ] - Vessel is active."
else
    echo "Checking Engine... [ ERROR ] - Podman is down. Restarting..."
    systemctl start podman
fi

# 2. List containers...
echo "Listing active containers:"
podman ps --format "ID: {{.ID}} | Image: {{.Image}} | Status: {{.Status}}"

# 3. Verify our resources...
echo "Checking resource usage..."
podman stats --no-stream

echo "Diagnostic complete. The vessel is secure."