#!/bin/bash

# Update packages
sudo apt update

# Install Apache2 web server
sudo apt install apache2 -y

# Start Apache2 service
sudo systemctl start apache2

# Enable Apache2 service to start automatically on boot
sudo systemctl enable apache2

# Check if Apache2 is running
if ! systemctl is-active --quiet apache2; then
  echo "Apache2 is not running. Please check the service status."
  exit 1
fi

# Add firewall rules to allow incoming traffic on port 80
sudo ufw allow http

# Get the IP address of the host machine
HOST_IP=$(hostname -I | awk '{print $1}')

# Create a virtual host file for Apache2
echo "<VirtualHost *:80>
    ServerName $HOSTNAME
    DocumentRoot /var/www/html
    <Directory /var/www/html>
        AllowOverride All
    </Directory>
</VirtualHost>" | sudo tee /etc/apache2/sites-available/000-default.conf > /dev/null

# Enable the virtual host
sudo a2ensite 000-default.conf

# Restart Apache2 service
sudo systemctl restart apache2

# Test the web server
if curl --output /dev/null --silent --head --fail "http://$HOST_IP"; then
  echo "Web server is up and running. You can access it by opening a web browser and navigating to http://$HOST_IP."
else
  echo "Failed to access the web server. Please check the Apache2 configuration."
  exit 1
fi
