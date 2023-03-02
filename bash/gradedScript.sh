#!/bin/bash

# Install LXD if necessary
if ! [ -x "$(command -v lxd)" ]; then
    sudo apt update
    sudo apt install lxd -y
fi

# Initialize LXD if no lxdbr0 interface exists
if ! ip a | grep -q "lxdbr0"; then
    sudo lxd init --auto
fi

# Launch container if necessary
if ! lxc list | grep -q "COMP2101-S22"; then
    lxc launch ubuntu:20.04 COMP2101-S22
fi

# Get container IP address
CONTAINER_IP=$(lxc list | grep "COMP2101-S22" | awk '{print $6}')

# Add or update hostname entry in /etc/hosts
if ! grep -q "COMP2101-S22" /etc/hosts; then
    echo "$CONTAINER_IP COMP2101-S22" | sudo tee -a /etc/hosts
else
    sudo sed -i "/COMP2101-S22/c\\$CONTAINER_IP COMP2101-S22" /etc/hosts
fi

# Install Apache2 in container if necessary
if ! lxc exec COMP2101-S22 -- command -v apache2 > /dev/null; then
    lxc exec COMP2101-S22 -- apt update
    lxc exec COMP2101-S22 -- apt install apache2 -y
fi

# Retrieve default web page from container's web service
if curl --output /dev/null --silent --head --fail http://COMP2101-S22; then
    echo "Success! Container's web service is accessible from the host."
else
    echo "Failure. Container's web service is not accessible from the host."
fi
