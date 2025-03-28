#!/usr/bin/zsh

# Jenkins variables
#  CLEAR_DB - (1/0) 
#  BUILD_ID is neeeded so Jenkins ProcessTreeKiller doesn't kill off sakai
BUILD_ID="bin/start.sh"

CATALINA_BASE=/var/sakai25-maria
cp catalina.properties  ${CATALINA_BASE}/conf/catalina.properties
cp context.xml ${CATALINA_BASE}/conf/context.xml
cp setenv.sh  ${CATALINA_BASE}/bin/setenv.sh
cp 25.properties ${CATALINA_BASE}/sakai/sakai.properties
cd ${CATALINA_BASE}
source bin/common.sh

DBSCRIPT="${WORKSPACE}/25-mysql.sql"
DBHOST=$(echo $PROPERTIES["url@javax.sql.BaseDataSource"] | $GREP_CMD -oP '(?<=:\/\/).+(?=:)')
DBNAME=$(echo $PROPERTIES["url@javax.sql.BaseDataSource"] | $GREP_CMD -oP '(?<=\/)\w+(?=\?)')
DBUSER=$PROPERTIES["username@javax.sql.BaseDataSource"]
DBPASS=$PROPERTIES["password@javax.sql.BaseDataSource"] 
bin/stop.sh -force || true
sleep 30

#Only run this between 0 and 4AM
typeset -i chour=10#`/bin/date +"%H"`
typeset -i cday=10#`/bin/date +"%u"`

typeset -i shour=0
typeset -i ehour=4
typeset -i cleardb=${CLEAR_DB:-0}

echo "Current hour is ${chour}. Current day is ${cday}"

if (( ${cleardb} != 1 && (${chour} >= ${shour}) && (${chour} <= ${ehour}) )); then
	cleardb=1
fi

if (( ${cleardb} == 1 )); then
    echo "Clearing database and assets"
    bin/clean-db.sh
fi

bin/clean-code.sh
tar xzf /tmp/sakai25x.tar.gz
bin/start.sh

if (( ${cleardb} == 1 )); then
    if [ -f "${DBSCRIPT}" ]; then
    	sleep 15m 
        mysql -f -h ${DBHOST} -u ${DBUSER} -p${DBPASS} ${DBNAME} -e "source ${DBSCRIPT}"
    fi
fi
