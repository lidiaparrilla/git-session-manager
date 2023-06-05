#!/bin/bash

# Check for necessary argument (username)
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

USERNAME=$1
CONFIG_PATH="$HOME/.ssh/session-configs/${USERNAME}.conf"

# Enter user details
read -p "Enter Git username for $USERNAME: " GIT_USERNAME
read -p "Enter Git email for $USERNAME: " GIT_EMAIL
read -p "Enter path to SSH key for $USERNAME: " SSHKEY

# Save the details into config
sudo echo "USERNAME=${GIT_USERNAME}" > "$CONFIG_PATH"
sudo echo "EMAIL=${GIT_EMAIL}" >> "$CONFIG_PATH"
sudo echo "SSHKEY=${SSHKEY}" >> "$CONFIG_PATH"

echo "User $USERNAME created successfully!"
