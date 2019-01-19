docker volume create portainer_data
docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock --restart=always --name portainer -v portainer_data:/data portainer/portainer
cd docker-build\grafana
docker build -t grafana:5.4.2-plugins --build-arg "GF_VERSION=5.4.2" --build-arg "GF_INSTALL_PLUGINS=jdbranham-diagram-panel,bessler-pictureit-panel,natel-plotly-panel,natel-discrete-panel" .
docker save --output grafana-5.4.2-plugins.tar grafana:5.4.2-plugins
