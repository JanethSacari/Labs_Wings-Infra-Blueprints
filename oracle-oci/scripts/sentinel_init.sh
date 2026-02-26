#!/bin/bash
# ==========================================================
# SCRIPT: Sentinel Fleet Node Initialization
# PURPOSE: Automated setup for Instance Pool members
# ==========================================================

echo "A new Sentinel joins the family..."

# Update and install required software
sudo yum update -y
sudo yum install -y httpd

# Start the service
sudo systemctl start httpd
sudo systemctl enable httpd

# Create a dynamic landing page showing the unique Instance ID
INSTANCE_ID=$(curl -s -H "Authorization: Bearer Oracle" http://169.254.169.254/opc/v2/instance/id)
DISPLAY_NAME=$(curl -s -H "Authorization: Bearer Oracle" http://169.254.169.254/opc/v2/instance/displayName)

cat <<EOF > /var/www/html/index.html
<html>
<body style="background-color: #1a2a6c; color: white; font-family: sans-serif; text-align: center; padding-top: 100px;">
    <h1>🪽 Sentinel Fleet Node Active</h1>
    <p><strong>Instance Name:</strong> $DISPLAY_NAME</p>
    <p><strong>Unique ID:</strong> $INSTANCE_ID</p>
    <p><em>"I'm the one who gripped you tight and raised you from perdition."</em></p>
</body>
</html>
EOF