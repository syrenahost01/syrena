#!/bin/bash

source .env

docker import ../docker-build/grafana/grafana-${GRAFANA_VERSION}-plugins.tar

docker-compose up --no-start

docker container start ${CONTAINER_NAMESPACE}-kafka-zookeeper

docker container start ${CONTAINER_NAMESPACE}-kafka-broker

while [ "`docker inspect -f {{.State.Running}} ${CONTAINER_NAMESPACE}-kafka-zookeeper`" != "true" ]; do sleep 15; done
while [ "`docker inspect -f {{.State.Running}} ${CONTAINER_NAMESPACE}-kafka-broker`" != "true" ]; do sleep 15; done
sleep 15
docker exec -it ${CONTAINER_NAMESPACE}-kafka-zookeeper kafka-topics --create --topic ${LOCAL_TOPIC} --partitions 1 --replication-factor 1 --if-not-exists --zookeeper ${CONTAINER_NAMESPACE}-kafka-zookeeper:2181
docker exec -it ${CONTAINER_NAMESPACE}-kafka-zookeeper kafka-topics --create --topic ${REMOTE_TOPIC} --partitions 1 --replication-factor 1 --if-not-exists --zookeeper ${CONTAINER_NAMESPACE}-kafka-zookeeper:2181

docker container start ${CONTAINER_NAMESPACE}-influxdb
while [ "`docker inspect -f {{.State.Running}} ${CONTAINER_NAMESPACE}-influxdb`" != "true" ]; do sleep 15; done
sleep 15
docker exec -it ${CONTAINER_NAMESPACE}-influxdb influx -execute 'create DATABASE syrena' -precision rfc3339

docker container start ${CONTAINER_NAMESPACE}-telegraf

docker container start ${CONTAINER_NAMESPACE}-grafana
