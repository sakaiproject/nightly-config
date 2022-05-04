#!/usr/bin/zsh

# Jenkins variables
#  CLEAR_DB - (1/0) 

CATALINA_BASE=/var/sakai-qa1-us-active
cp 21.properties ${CATALINA_BASE}/sakai/sakai.properties
cd ${CATALINA_BASE}

source bin/common.sh

DBSCRIPT="${WORKSPACE}/master-mysql.sql"
DBHOST=$(echo $PROPERTIES["url@javax.sql.BaseDataSource"] | $GREP_CMD -oP '(?<=:\/\/).+(?=:)')
DBNAME=$(echo $PROPERTIES["url@javax.sql.BaseDataSource"] | $GREP_CMD -oP '(?<=\/)\w+(?=\?)')
DBUSER=$PROPERTIES["username@javax.sql.BaseDataSource"]
DBPASS=$PROPERTIES["password@javax.sql.BaseDataSource"]

bin/stop.sh -force || true
sleep 30

#Only run this between 0 and 5AM
typeset -i chour=10#`/bin/date +"%H"`
typeset -i dow=10#`/bin/date +"%u"`
# This is %u so 1 (Monday) - 7 (Sunday)
typeset -i dowclear=1
typeset -i shour=0
typeset -i ehour=5
typeset -i cleardb=${CLEAR_DB:-0}

echo "Current hour is ${chour}. Current day is ${dow}"

if (( (${chour} >= ${shour}) && (${chour} <= ${ehour}) )); then
    echo "Dow is ${dow} clear on ${dowclear}"
    if (( ${dow} == ${dowclear} )); then
        cleardb=1
    fi
fi

if (( ${cleardb} == 1 )); then
    echo "Clearing database and assets"
    bin/clean-db.sh
fi

bin/clean-code.sh
tar xzf /tmp/sakai-qa1.tar.gz
nohup bin/start.sh

if (( ${cleardb} == 1 )); then
    if [ -f "${DBSCRIPT}" ]; then
    	sleep 15m 
        mysql -f -h ${DBHOST} -u ${DBUSER} -p${DBPASS} ${DBNAME} -e "source ${DBSCRIPT}"
    fi
fi
