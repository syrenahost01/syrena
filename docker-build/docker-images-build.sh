source .env

cd grafana
docker build -t grafana:${GRAFANA_VERSION}-plugins \
  --build-arg "GF_VERSION="${GRAFANA_VERSION} \
  --build-arg "GF_INSTALL_PLUGINS=jdbranham-diagram-panel,bessler-pictureit-panel,natel-plotly-panel,natel-discrete-panel" .

docker save --output grafana-${GRAFANA_VERSION}-plugins.tar grafana:${GRAFANA_VERSION}-plugins
