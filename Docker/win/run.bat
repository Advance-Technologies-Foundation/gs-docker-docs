call .\Docker\win\default-env.bat

SET COMMON_DB_TYPE=%1
SET WORKER_DB_TYPE=%2
SET DOCKER_TAG=%3

IF "%COMMON_DB_TYPE%" == "" (
	ECHO "ERROR: You must set COMMON_DB_TYPE (mssql or mysql) 'Docker/win/run.bat [COMMON_DB_TYPE] [WORKER_DB_TYPE] [DOCKER_TAG]'"
    Exit /b
)

IF "%WORKER_DB_TYPE%" == "" (
	ECHO "ERROR: You must set WORKER_DB_TYPE (mssql or oracle) 'Docker/win/run.bat [COMMON_DB_TYPE] [WORKER_DB_TYPE] [DOCKER_TAG]'"
    Exit /b
)

IF "%DOCKER_TAG%" == "" (
	ECHO "ERROR: You must set DOCKER_TAG (example: 1.0) 'Docker/win/run.bat [COMMON_DB_TYPE] [WORKER_DB_TYPE] [DOCKER_TAG]'"
    Exit /b
)

IF "%COMMON_DB_TYPE%" == "mssql" (
   ECHO "run . Docker\win\mssql-env.bat"
   call .\Docker\win\mssql-env
)

IF "%COMMON_DB_TYPE%" == "mysql" (
   ECHO "run . Docker\win\mysql-env.bat"
   call .\Docker\win\mysql-env
)

IF "%WORKER_DB_TYPE%" == "oracle" (
   ECHO "run . Docker\win\oracle-env.bat"
   call .\Docker\win\oracle-env
)

docker network create --subnet=172.18.0.0/16 net1

IF "%RUN_ELASTICSEARCH%"=="1" (docker rm -f es-node1)
IF "%RUN_ELASTICSEARCH%"=="1" (docker rm -f es-node2)
IF "%RUN_RABBITMQ%"=="1" (docker rm -f rabbitmq)
IF "%RUN_MYSQL%"=="1" (docker rm -f gs-mysql)

docker rm -f gs-mysql
docker rm -f gs-scheduler

docker rm -f gs-worker-01
docker rm -f gs-worker-02
docker rm -f gs-worker-03

docker rm -f gs-worker-replay
docker rm -f gs-worker-single
docker rm -f gs-web-api
docker rm -f gs-web-indexing-service

IF "%RUN_ELASTICSEARCH%"=="1" (call .\Docker\elasticsearch\build.bat)
IF "%RUN_ELASTICSEARCH%"=="1" (call .\Docker\elasticsearch\run.bat)
IF "%RUN_RABBITMQ%"=="1" (call .\Docker\rabbitmq\run.bat)
IF "%RUN_MYSQL%"=="1" (call .\Docker\mysql\run.bat)

call .\Docker\scheduler\run.bat
call .\Docker\worker\run.bat gs-worker-01
call .\Docker\worker\run.bat gs-worker-02
call .\Docker\worker\run.bat gs-worker-03

call .\Docker\worker-replay\run.bat
call .\Docker\web-api\run.bat

:: call .\Docker\web-indexing-service\run.bat
:: call .\Docker\worker-single\run.bat