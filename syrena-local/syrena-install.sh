#!/bin/bash

source .env

sudo docker import ../docker-build/grafana/grafana-${GRAFANA_VERSION}-plugins.tar

sudo docker-compose up --no-start

sudo docker container start ${CONTAINER_NAMESPACE}-kafka-zookeeper

sudo docker container start ${CONTAINER_NAMESPACE}-kafka-broker

while [ "`sudo docker inspect -f {{.State.Running}} ${CONTAINER_NAMESPACE}-kafka-zookeeper`" != "true" ]; do sleep 15; done
while [ "`sudo docker inspect -f {{.State.Running}} ${CONTAINER_NAMESPACE}-kafka-broker`" != "true" ]; do sleep 15; done
sleep 15
sudo docker exec -it ${CONTAINER_NAMESPACE}-kafka-zookeeper kafka-topics --create --topic ${LOCAL_TOPIC} --partitions 1 --replication-factor 1 --config cleanup.policy=${KAFAKA_CLEANUP_POLICY} --config compression.type=${KAFKA_COMPRESSION_TYPE} --config retention.ms=${KAFKA_RETENTION_MS} --if-not-exists --zookeeper ${CONTAINER_NAMESPACE}-kafka-zookeeper:2181
sudo docker exec -it ${CONTAINER_NAMESPACE}-kafka-zookeeper kafka-topics --create --topic ${REMOTE_TOPIC} --partitions 1 --replication-factor 1 --config cleanup.policy=${KAFAKA_CLEANUP_POLICY} --config compression.type=${KAFKA_COMPRESSION_TYPE} --config retention.ms=${KAFKA_RETENTION_MS} --if-not-exists --zookeeper ${CONTAINER_NAMESPACE}-kafka-zookeeper:2181

sudo docker container start ${CONTAINER_NAMESPACE}-influxdb
while [ "`sudo docker inspect -f {{.State.Running}} ${CONTAINER_NAMESPACE}-influxdb`" != "true" ]; do sleep 15; done
sleep 15
sudo docker exec -it ${CONTAINER_NAMESPACE}-influxdb influx -execute 'create DATABASE syrena WITH DURATION ${RETENTION_DURATION} NAME ${RETENTION_POLICY_NAME}' -precision rfc3339

sudo docker container start ${CONTAINER_NAMESPACE}-telegraf

sudo docker container start ${CONTAINER_NAMESPACE}-grafana
