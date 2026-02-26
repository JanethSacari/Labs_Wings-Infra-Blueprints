#!/bin/bash

# ==========================================================
# BLUEPRINT: Cas Sentinel Initialization
# PROJECT: Wings-Infra-Blueprints
# DESCRIPTION: Automated software configuration via Cloud-init
# ==========================================================

echo "Constructing the Sentinel... (Initializing Cloud-init)"

# 1. Update the OS packages (Keeping the 'vessel' secure)
sudo yum update -y

# 2. Install essential tools (The Sentinel's weapons)
# Installing Apache (httpd) as an example of automated software setup
sudo yum install -y httpd git curl

# 3. Start and enable the service
sudo systemctl start httpd
sudo systemctl enable httpd

# 4. Create a custom landing page (The Mark of the Sentinel)
cat <<EOF > /var/www/html/index.html
<html>
    <head>
        <title>Wings-Infra-Blueprints</title>
        <style>
            body { font-family: sans-serif; background-color: #f0f4f8; color: #2c3e50; text-align: center; padding: 50px; }
            h1 { color: #2980b9; }
            .angel-seal { font-size: 50px; margin-bottom: 20px; }
        </style>
    </head>
    <body>
        <div class="angel-seal">🪽</div>
        <h1>Sentinel Instance Active</h1>
        <p>Managed by <strong>Wings-Infra-Blueprints</strong></p>
        <p>Status: Under the protection of the Chosen Family.</p>
        <hr>
        <p>Instance Metadata: $(curl -s -H "Authorization: Bearer Oracle" http://169.254.169.254/opc/v2/instance/displayName)</p>
    </body>
</html>
EOF

# 5. Configure Firewall (Opening the gates: Port 80)
sudo firewall-offline-cmd --add-port=80/tcp
sudo systemctl restart firewalld

echo "Sentinel construction complete. The Mark is set."