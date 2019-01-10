sudo apt-get update
sudo apt-get install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce

sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo docker --version
sudo docker-compose --version

sudo docker volume create portainer_data
sudo docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock --restart=always --name portainer -v portainer_data:/data portainer/portainer

chmod +x syrena-central/syrena-install.sh
chmod +x syrena-local/syrena-install.sh
chmod +x syrena-tablette/syrena-install.sh

chmod +x syrena-central/mmchangetopic/launch
chmod +x syrena-local/mmchangetopic/launch
chmod +x syrena-tablette/mmchangetopic/launch
