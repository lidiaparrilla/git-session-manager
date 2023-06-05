#!/bin/bash
# script name: git_session.sh

# Validate arguments
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

USERNAME=$1
CONFIG_PATH="$HOME/.ssh/session-configs/${USERNAME}.conf"

# Backup current git config
GIT_USERNAME=$(git config --global user.name)
GIT_EMAIL=$(git config --global user.email)
GIT_SSH_COMMAND=$(git config --global core.sshCommand)

# Check if current git config is already set to a different user
if [ "$GIT_USERNAME" != "" ] && [ "$GIT_USERNAME" != "$USERNAME" ]; then
    echo "Warning: Git is already configured for another user ($GIT_USERNAME)."
    echo "To clean up the previous session, please run the following commands:"
    echo "    git config --global --unset user.name"
    echo "    git config --global --unset user.email"
    echo "    git config --global --unset core.sshCommand"
    exit 1
fi

# Check if configuration file exists
if [ ! -f "$CONFIG_PATH" ]; then
    echo "No configuration found for user ${USERNAME}. Creating a new one"
    sudo touch $CONFIG_PATH
fi

# Source the configuration
source "$CONFIG_PATH"

# Set the new git config
git config --global user.name "$USERNAME"
git config --global user.email "$EMAIL"
git config --global core.sshCommand "ssh -i $SSHKEY -F /dev/null"

echo "Git session started for user $USERNAME."

# Create a cleanup function that will be called upon script exit
function cleanup {
    git config --global user.name "$GIT_USERNAME"
    git config --global user.email "$GIT_EMAIL"
    git config --global core.sshCommand "$GIT_SSH_COMMAND"
    echo "Git session ended for user $USERNAME."
}

# Register the cleanup function to be called on the EXIT signal
trap cleanup EXIT

# Start a new interactive shell to allow the user to interact with git
bash
