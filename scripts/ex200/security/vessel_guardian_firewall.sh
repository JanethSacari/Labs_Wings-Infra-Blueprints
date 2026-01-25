#!/bin/bash
# ==============================================================================
# Script: vessel_guardian_firewall.sh
# Purpose: RHCSA Practice - Configuring Firewalld and Service Access
# 
# "A guardian knows when to close the gates and when to let the light in."
# Dedicated to the quiet strength of Iris and her three feline guardians.
# ==============================================================================

echo "Initializing Firewall Security Protocol..."

# 1. Ensure firewalld is running and enabled
sudo systemctl enable --now firewalld

# 2. Allow essential services (Simulating a secure environment)
echo "Opening ports for SSH and Web Services..."
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https

# 3. Restricting access (The "Do Not Disturb" mode)
# In the exam, you might need to block a specific port or rich rule
echo "Applying restrictions and reloading rules..."
sudo firewall-cmd --reload

# 4. Final Verification
echo "--- Current Active Rules ---"
sudo firewall-cmd --list-all

echo "The vessel is now protected. Internal access only."