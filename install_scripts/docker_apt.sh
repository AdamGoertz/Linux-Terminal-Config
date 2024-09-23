## Add Docker's official GPG key:
#sudo apt-get update
#sudo apt-get install -y ca-certificates curl pass jq
#sudo install -m 0755 -d /etc/apt/keyrings
#sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
#sudo chmod a+r /etc/apt/keyrings/docker.asc
#
## TODO: Generate GPG key and init pass
## gpg --quick-generate-key $(whoami) rsa3072
## pass init <GPG_PUB_ID>
#
#DOCKER_CREDS="pass-v0.8.1.linux-$(dpkg --print-architecture)"
#wget -nc https://github.com/docker/docker-credential-helpers/releases/download/v0.8.1/$DOCKER_CREDS -O ~/.local/bin/docker-credentials-$DOCKER_CREDS
#sudo chmod +x ~/.local/bin/docker-credentials-$DOCKER_CREDS
#
## Add the repository to Apt sources:
#echo \
#  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
#  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
#  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#sudo apt-get update
#sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
#
#mkdir -p ~/.docker
#touch ~/.docker/config.json
cat ~/.docker/config.json | jq ". += {\"credsStore\": \"$DOCKER_CREDS\"}" > ~/.docker/config.json

# sudo usermod -aG docker $(whoami)
