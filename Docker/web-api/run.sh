#!/bin/bash
docker run -d \
	--name gs-web-api \
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
	-p $WEB_API_PORT:80 \
	"$DOCKER_HUB_LOGIN""gs-web-api:""$DOCKER_TAG"