# Git Session Manager

Tired of having to change the user, email and path to private SSH key manually when working with Git on a shared server? Hopeless with understanding and managing Git and SSH agents shenanigans? 

<b>This is your tool!</b>

This repository contains a utility to easily set up git sessions in shared working environments. And even more: You don't need to learn how to use a new tool, as this will be behaving as an internal Git command. Keep reading to understand how.

# Table of Contents

  * [Installation](#installation)
  * [Usage](#usage)

# Installation

1. Download the installation script:

`wget https://raw.githubusercontent.com/lidiaparrilla/git-session-manager/main/install.sh`

2. Set execute permissions

`sudo chmod +x install.sh`

3. Execute (without sudo):

`./install.sh`

4. Clean installation file:

`rm install.sh`

To uninstall, follow the same steps, but with the next file:
`wget https://raw.githubusercontent.com/lidiaparrilla/git-session-manager/main/uninstall.sh`

# Usage

The installation will provide 2 new commands that are used as internal git commands.

## Session creation

Create a new session, with its corresponding user name, email and path to SSH private key.

`git session-create <username>`

The utility will then ask for the user name, e-mail and path to the SSH RSA private key. To create this private key, you can use ssh-keygen. Read more [here](https://www.ssh.com/academy/ssh/keygen).

After that, you will see that a new file <username>.config has been created under `~/.ssh/sessions-config/` folder.

## Session start

Activate an existing Git session, that will last for the duration of the current window session.

`git session-start <username>`

If the corresponding session exists, it will be enabled. From that moment on, any interaction with the repository will be made in the name of the selected user and using that SSH key for interaction with the remote repository (GitLab, GitHub, etc.).

The session can be exited at any moment by doing `exit` or just leaving the current SSH session. This will resore Git settings to default user and clean the SSH key reference to avoid accidental commit in other's name in a future login.
