#!/usr/bin/env bash

# TODO: This needs some cleanup
# Used to configure git credential manager to enable pushing from HTTPS connections

wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.5.1/gcm-linux_amd64.2.5.1.deb
sudo dpkg -i gcm-linux_amd64.2.5.1.deb

git config --global credential.credentialStore gpg

gpg --quick-generate-key $(whoami) rsa3072

sudo apt-get install -y pass

# pass init <gpg_id>
