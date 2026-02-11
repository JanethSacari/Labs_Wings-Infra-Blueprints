#!/bin/bash

# ==============================================================================
# Script: setup_wings_vessel.sh
# Purpose: Provisioning & Health Checking a Java 8 Environment on OCI
# Profile: Mission Critical Architecture
# ==============================================================================

# Colors for better observability in the terminal
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}--- [1/5] Updating System & Security Patches ---${NC}"
sudo yum update -y > /dev/null

echo -e "${GREEN}--- [2/5] Installing Java 8 Runtime & Tools ---${NC}"
sudo yum install java-1.8.0-openjdk-devel -y > /dev/null

echo -e "${GREEN}--- [3/5] Configuring Environment Variables ---${NC}"
# Simulating a secure injection of credentials
export APP_STATUS="ACTIVE"
export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")

echo -e "${GREEN}--- [4/5] Starting Health Check Procedure ---${NC}"

# 1. Check if Java is actually installed
if type -p java > /dev/null; then
    echo -e "  [PASS] Java executable found."
else
    echo -e "${RED}  [FAIL] Java NOT found. Check installation.${NC}"
    exit 1
fi

# 2. Check Java Version (Must be 1.8 for this specific legacy/banking project)
JAVA_VER=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2)
if [[ "$JAVA_VER" == "1.8"* ]]; then
    echo -e "  [PASS] Java version is $JAVA_VER."
else
    echo -e "${RED}  [FAIL] Incorrect Java version: $JAVA_VER. Expected 1.8.${NC}"
    exit 1
fi

# 3. Check System Memory (Crucial for avoiding OOM in Mission Critical systems)
FREE_MEM=$(free -m | awk '/^Mem:/{print $4}')
if [ "$FREE_MEM" -gt 512 ]; then
    echo -e "  [PASS] Sufficient memory available: ${FREE_MEM}MB."
else
    echo -e "${RED}  [WARNING] Low memory detected: ${FREE_MEM}MB. OOM risk high!${NC}"
fi

echo -e "${GREEN}--- [5/5] Finalizing Setup ---${NC}"
echo "Vessel Status: $APP_STATUS"
echo -e "${GREEN}SYSTEM READY FOR MISSION DEPLOYMENT.${NC}"
