#!/bin/bash
docker run -d \
	--name gs-web-indexing-service \
	-e DbDialectProvider="$GS_COMMON_DB_DIALECT_PROVIDER" \
	-e connectionStrings__db="$GS_DB_CONNECTION_STRING" \
	-e connectionStrings__RabbitMQ="$GS_RABBITMQ_AMQP" \
	-e RabbitMQSettings__RabbitQueueName="$GS_RABBITMQ_QUEUE_NAME_SINGLE_INBOX" \
	-e RabbitMQSettings__DBServerNameTemplate="$GS_DB_SERVER_NAME_TEMPLATE" \
	--net net1 \
	--add-host rabbitmq:"$RABBITMQ_IP" \
	-p 82:80 \
	"$DOCKER_HUB_LOGIN""gs-web-indexing-service:""$DOCKER_TAG"