$CONTAINER_NAMESPACE="syrena-tablette"          
$ZOOKEEPER_VERSION="5.1.0"
$KAFKA_VERSION="5.1.0"
$MIRRORMAKER_VERSION="5.0.0"
$TELEGRAF_VERSION="1.9-alpine"
$INFLUXDB_VERSION="1.7-alpine"
$GRAFANA_VERSION="5.4.2"

$KAFKA_LOCAL_BROKER_HOSTNAME="syrena-sna1-tablette3.duckdns.org"
$KAFKA_REMOTE_BROKER_HOSTNAME="syrena-sna1-local.duckdns.org"
$LOCAL_TOPIC="syrena-tablette"
$REMOTE_TOPIC="syrena-local"

$KAFAKA_CLEANUP_POLICY="delete"
$KAFKA_COMPRESSION_TYPE="gzip"
$KAFKA_RETENTION_MS="43200000"

docker import ../docker-build/grafana/grafana-5.4.2-plugins.tar

docker-compose up --no-start

docker container start syrena-tablette-kafka-zookeeper

docker container start syrena-tablette-kafka-broker

Start-Sleep -Seconds 15

docker exec -it syrena-tablette-kafka-zookeeper kafka-topics --create --topic syrena-tablette --partitions 1 --replication-factor 1 --config cleanup.policy=delete --config compression.type=gzip --config retention.ms=43200000 --if-not-exists --zookeeper syrena-tablette-kafka-zookeeper:2181

docker exec -it syrena-tablette-kafka-zookeeper kafka-topics --create --topic syrena-local --partitions 1 --replication-factor 1 --config cleanup.policy=delete --config compression.type=gzip --config retention.ms=43200000 --if-not-exists --zookeeper syrena-tablette-kafka-zookeeper:2181

docker container start syrena-tablette-influxdb

Start-Sleep -Seconds 15

#docker exec -it syrena-tablette-influxdb influx -execute 'create DATABASE syrena WITH DURATION 1d NAME "syrena-tablette"'

docker container start syrena-tablette-telegraf

docker container start syrena-tablette-grafana
