#!/bin/bash

# 1. Download script git-session-start from a github repository
wget -O git-session-start <https://raw.githubusercontent.com/lidiaparrilla/git-session-manager/main/src/git-session-start.sh>

# 2. Change permissions
chmod +x git-session-start.sh

# 3. Copy script to somewhere in path
sudo mv git-session-start.sh /usr/local/bin/git-session-start

# 4. Create alias in git for starting a session
git config --global alias.session '!git-session-start'

# 5. Create settings folder
mkdir -p ~/.ssh/session-configs

# 6. Download script git-session-create.sh from a github repository
wget -O git-session-create.sh <https://raw.githubusercontent.com/lidiaparrilla/git-session-manager/main/src/git-session-create.sh>

# 7. Change permissions
chmod +x git-session-create.sh

# 8. Copy script to somewhere in path
sudo mv git-session-create.sh /usr/local/bin/git-session-create

# 9. Create alias in git for creating a user
git config --global alias.session-create '!git-session-create.sh'

echo "Installation completed successfully!"
echo "Usage:"
echo "  - To create a new Git session user, use 'git session-create <username>'."
echo "  - To start a Git session, use 'git session-start <username>'."
