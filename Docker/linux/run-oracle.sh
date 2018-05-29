#!/bin/bash
. Docker/linux/default-env
. Docker/linux/oracle-env
. Docker/linux/test-oracle-env

COMMON_DB_TYPE=mssql 
WORKER_DB_TYPE=oracle
DOCKER_TAG=$1
export DOCKER_TAG=$DOCKER_TAG

docker run -d \
	--name gs-scheduler-oracle \
	-e DbDialectProvider="$GS_COMMON_DB_DIALECT_PROVIDER" \
	-e connectionStrings__db="$GS_DB_CONNECTION_STRING" \
	-e connectionStrings__RabbitMQ="$GS_RABBITMQ_AMQP" \
	-e RabbitMQSettings__RabbitQueueName="$GS_RABBITMQ_QUEUE_NAME_INBOX" \
	-e RabbitMQSettings__ReplyRabbitQueueName="$GS_RABBITMQ_QUEUE_NAME_OUTBOX" \
	-e RabbitMQSettings__FillQueueInterval="$GS_DB_FILL_QUEUE_INTERVAL" \
	-e RabbitMQSettings__DataCenterName="$GS_DATACENTER_NAME" \
	-e RabbitMQSettings__DBServerNameTemplate="$GS_DB_SERVER_NAME_TEMPLATE" \
	--net net1 \
	--add-host rabbitmq:"$RABBITMQ_IP" \
	--add-host gs-mysql:"$MYSQL_IP" \
	"$DOCKER_HUB_LOGIN""gs-scheduler:""$DOCKER_TAG"

docker run -d \
	--name gs-web-api-oracle \
	-e DbDialectProvider="$GS_COMMON_DB_DIALECT_PROVIDER" \
	-e ApiKey="$GS_API_KEY" \
	-e RequestTimeOut="$GS_REQUEST_TIMEOUT" \
	-e elasticLogin="$GS_ES_LOGIN" \
	-e elasticPassword="$GS_ES_PASSWORD" \
	-e OnSiteClientSettings__ElasticSearchUrl="$GS_ES_URL" \
	-e connectionStrings__db="$GS_DB_CONNECTION_STRING" \
	-e connectionStrings__RabbitMQ="$GS_RABBITMQ_AMQP" \
	--net net1 \
	--add-host elasticsearch:"$ELASTICSEARCH_IP" \
	--add-host gs-mysql:"$MYSQL_IP" \
	-p 83:80 \
	"$DOCKER_HUB_LOGIN""gs-web-api:""$DOCKER_TAG"

docker run -d \
	--name gs-web-indexing-service-oracle \
	-e DbDialectProvider="$GS_COMMON_DB_DIALECT_PROVIDER" \
	-e connectionStrings__db="$GS_DB_CONNECTION_STRING" \
	-e connectionStrings__RabbitMQ="$GS_RABBITMQ_AMQP" \
	-e RabbitMQSettings__RabbitQueueName="$GS_RABBITMQ_QUEUE_NAME_SINGLE_INBOX" \
	-e RabbitMQSettings__DBServerNameTemplate="$GS_DB_SERVER_NAME_TEMPLATE" \
	--net net1 \
	--add-host rabbitmq:"$RABBITMQ_IP" \
	-p 84:80 \
	"$DOCKER_HUB_LOGIN""gs-web-indexing-service:""$DOCKER_TAG"

docker run -d \
	--name gs-worker-oracle-01 \
	-e DbDialectProvider="$GS_WORKER_DB_DIALECT_PROVIDER" \
	-e DBConnectionConfigPattern="$GS_WORKER_DB_CONNECTION_STRING_PATTERN" \
	-e elasticLogin="$GS_ES_LOGIN" \
	-e elasticPassword="$GS_ES_PASSWORD" \
	-e RequestTimeOut="$GS_REQUEST_TIMEOUT" \
	-e OnSiteClientSettings__ElasticSearchUrl="$GS_ES_URL" \
	-e connectionStrings__db="$GS_DB_CONNECTION_STRING" \
	-e connectionStrings__RabbitMQ="$GS_RABBITMQ_AMQP" \
	-e RabbitMQSettings__RabbitQueueName="$GS_RABBITMQ_QUEUE_NAME_INBOX" \
	-e RabbitMQSettings__ReplyRabbitQueueName="$GS_RABBITMQ_QUEUE_NAME_OUTBOX" \
	-e RabbitMQSettings__IncrementDays="$GS_DB_INCREMENT_DAYS" \
	--net net1 \
	--add-host rabbitmq:"$RABBITMQ_IP" \
	--add-host elasticsearch:"$ELASTICSEARCH_IP" \
	"$DOCKER_HUB_LOGIN""gs-worker:""$DOCKER_TAG"

docker run -d \
	--name gs-worker-oracle-02 \
	-e DbDialectProvider="$GS_WORKER_DB_DIALECT_PROVIDER" \
	-e DBConnectionConfigPattern="$GS_WORKER_DB_CONNECTION_STRING_PATTERN" \
	-e elasticLogin="$GS_ES_LOGIN" \
	-e elasticPassword="$GS_ES_PASSWORD" \
	-e RequestTimeOut="$GS_REQUEST_TIMEOUT" \
	-e OnSiteClientSettings__ElasticSearchUrl="$GS_ES_URL" \
	-e connectionStrings__db="$GS_DB_CONNECTION_STRING" \
	-e connectionStrings__RabbitMQ="$GS_RABBITMQ_AMQP" \
	-e RabbitMQSettings__RabbitQueueName="$GS_RABBITMQ_QUEUE_NAME_INBOX" \
	-e RabbitMQSettings__ReplyRabbitQueueName="$GS_RABBITMQ_QUEUE_NAME_OUTBOX" \
	-e RabbitMQSettings__IncrementDays="$GS_DB_INCREMENT_DAYS" \
	--net net1 \
	--add-host rabbitmq:"$RABBITMQ_IP" \
	--add-host elasticsearch:"$ELASTICSEARCH_IP" \
	"$DOCKER_HUB_LOGIN""gs-worker:""$DOCKER_TAG"

docker run -d \
	--name gs-worker-replay-oracle \
	-e DbDialectProvider="$GS_COMMON_DB_DIALECT_PROVIDER" \
	-e connectionStrings__db="$GS_DB_CONNECTION_STRING" \
	-e connectionStrings__RabbitMQ="$GS_RABBITMQ_AMQP" \
	-e RabbitMQSettings__RabbitQueueName="$GS_RABBITMQ_QUEUE_NAME_INBOX" \
	-e RabbitMQSettings__ReplyRabbitQueueName="$GS_RABBITMQ_QUEUE_NAME_OUTBOX" \
	--net net1 \
	--add-host rabbitmq:"$RABBITMQ_IP" \
	"$DOCKER_HUB_LOGIN""gs-worker-replay:""$DOCKER_TAG"

docker run -d \
	--name gs-worker-single-oracle \
	-e DbDialectProvider="$GS_WORKER_DB_DIALECT_PROVIDER" \
	-e DBConnectionConfigPattern="$GS_WORKER_DB_CONNECTION_STRING_PATTERN" \
	-e elasticLogin="$GS_ES_LOGIN" \
	-e elasticPassword="$GS_ES_PASSWORD" \
	-e RequestTimeOut="$GS_REQUEST_TIMEOUT" \
	-e OnSiteClientSettings__ElasticSearchUrl="$GS_ES_URL" \
	-e connectionStrings__RabbitMQ="$GS_RABBITMQ_AMQP" \
	-e RabbitMQSettings__RabbitQueueName="$GS_RABBITMQ_QUEUE_NAME_SINGLE_INBOX" \
	--net net1 \
	--add-host rabbitmq:"$RABBITMQ_IP" \
	--add-host elasticsearch:"$ELASTICSEARCH_IP" \
	"$DOCKER_HUB_LOGIN""gs-worker-single:""$DOCKER_TAG"