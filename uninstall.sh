git config --global --unset alias.session-create
git config --global --unset alias.session-start
sudo rm /usr/local/bin/git-session-start
sudo rm /usr/local/bin/git-session-create
rm -r ~/.ssh/session-configs