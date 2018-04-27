set RUN_ELASTICSEARCH=1
set RUN_RABBITMQ=1
set RUN_MYSQL=1

set GLOBALSEARCH_VOLUME=c:/data/globalsearch
set ES1_VOLUME=c:/data/es1
set ES2_VOLUME=c:/data/es2
set RABBITMQ_VOLUME=c:/data/rabbitmq
set MYSQL_VOLUME=c:/data/mysql

set RABBITMQ_IP=172.18.0.10 
set ELASTICSEARCH_IP=172.18.0.11
set MYSQL_IP=172.18.0.12

set MYSQL_USER=root
set MYSQL_PASSWORD=1665017

set GS_RABBITMQ_AMQP="amqp://gs:gs@rabbitmq:5672/"
set GS_RABBITMQ_QUEUE_NAME_INBOX="inbox"
set GS_RABBITMQ_QUEUE_NAME_OUTBOX="outbox"
set GS_RABBITMQ_QUEUE_NAME_SINGLE_INBOX="single-inbox"

set GS_DB_BATCH_SIZE="2000"
set GS_DB_INCREMENT_DAYS="500"
set GS_DB_FILL_QUEUE_INTERVAL="30000"
set GS_DB_SERVER_NAME_TEMPLATE="{0}"
set GS_DATACENTER_NAME="OnSiteDataCenter"

set GS_ES_URL="http://[WindowsHostName]:9200"
set GS_ES_LOGIN=""
set GS_ES_PASSWORD=""
set GS_REQUEST_TIMEOUT="600000"
set GS_API_KEY="testKey"

set GS_CONFIG_DIRECTORY="/usr/share/globalsearch/fileConfigs/"

set DOCKER_HUB_LOGIN="bpmonline/"

set SCHEDULER_CONFIG_FOLDER="SchedulerConfig"
set WEB_API_CONFIG_FOLDER="WebAppConfig"
set WEB_INDEXING_SERVICE_CONFIG_FOLDER="WebIndexindServiceConfig"
set WORKER_CONFIG_FOLDER="WorkerConfig"
set WORKER_REPLAY_CONFIG_FOLDER="ReplayWorkerConfig"
set WORKER_SINGLE_CONFIG_FOLDER="WorkerSingleConfig"

set GS_WORKER_DB_DIALECT_PROVIDER="ServiceStack.OrmLite.SqlServerDialect, ServiceStack.OrmLite.SqlServer, Culture=neutral, PublicKeyToken=null"
set GS_WORKER_DB_CONNECTION_STRING_PATTERN="Server=[DBServerName]; Database=[DBName]; User Id=[DBLogin]; Password=[DBPassword]; Connection Timeout=10"