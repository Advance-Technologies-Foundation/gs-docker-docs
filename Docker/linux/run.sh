#!/bin/bash
. Docker/linux/default-env

COMMON_DB_TYPE=$1
WORKER_DB_TYPE=$2
DOCKER_TAG=$3
export DOCKER_TAG=$DOCKER_TAG

if [ -z "$COMMON_DB_TYPE" ]; then
   echo "ERROR: You must set COMMON_DB_TYPE (mysql or mssql) 'Docker/linux/run.sh [COMMON_DB_TYPE] [WORKER_DB_TYPE] [DOCKER_TAG]'"
   exit
fi

if [ -z "$WORKER_DB_TYPE" ]; then
   echo "ERROR: You must set WORKER_DB_TYPE (mssql or oracle) 'Docker/linux/run.sh [COMMON_DB_TYPE] [WORKER_DB_TYPE] [DOCKER_TAG]'"
   exit
fi

if [ -z "$DOCKER_TAG" ]; then
   echo "ERROR: You must set DOCKER_TAG (example: 1.0) 'Docker/linux/run.sh [COMMON_DB_TYPE] [WORKER_DB_TYPE] [DOCKER_TAG]'"
   exit
fi

if [ $COMMON_DB_TYPE = "mssql" ]; then
   echo "run . Docker/linux/mssql-env"
	. Docker/linux/mssql-env
fi

if [ $COMMON_DB_TYPE = "mysql" ]; then
   echo "run . Docker/linux/mysql-env"
	. Docker/linux/mysql-env
fi

if [ $WORKER_DB_TYPE = "oracle" ]; then
   echo "run . Docker/linux/oracle-env"
	. Docker/linux/oracle-env
fi

docker volume create globalsearch
if [ $RUN_ELASTICSEARCH = 1 ]; then
   docker volume create es1
   docker volume create es2
fi
if [ $RUN_RABBITMQ = 1 ]; then
   docker volume create rabbitmq
fi
if [ $RUN_MYSQL = 1 ]; then
   docker volume create mysql
fi
docker network create --subnet=172.18.0.0/16 net1

if [ $RUN_ELASTICSEARCH = 1 ]; then
   docker rm -f es-node1
   docker rm -f es-node2
fi
if [ $RUN_RABBITMQ = 1 ]; then
   docker rm -f rabbitmq
fi
docker rm -f gs-mysql
docker rm -f gs-scheduler

docker rm -f gs-worker-01
docker rm -f gs-worker-02
docker rm -f gs-worker-03

docker rm -f gs-worker-replay

docker rm -f gs-web-api

#docker rm -f gs-web-indexing-service
#docker rm -f gs-worker-single

if [ $RUN_ELASTICSEARCH = 1 ]; then
   sh Docker/elasticsearch/build.sh
   sh Docker/elasticsearch/run.sh
fi
if [ $RUN_RABBITMQ = 1 ]; then
   sh Docker/rabbitmq/run.sh
fi
if [ $RUN_MYSQL = 1 ]; then
   echo "sh Docker/mysql/run.sh"
   sh Docker/mysql/run.sh
fi
sh Docker/scheduler/run.sh

# run 3 worker by defaul 
sh Docker/worker/run.sh gs-worker-01
sh Docker/worker/run.sh gs-worker-02
sh Docker/worker/run.sh gs-worker-03

sh Docker/worker-replay/run.sh
sh Docker/web-api/run.sh

# sh Docker/web-indexing-service/run.sh
# sh Docker/worker-single/run.sh