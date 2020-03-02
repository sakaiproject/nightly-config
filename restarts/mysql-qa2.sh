#Most of these variables need to be defined externally (in Jenkins)
#  These include 
#  CLEAR_DB - (1/0) 
#  MYSQLDB - Host name for MySQL
#  MYSQLQA12DB - Password for this database

TAG=20.0-rc01
BUILD_ID=bin/startup.sh
CATALINA_BASE=/var/sakai-qa2-us-active
DBSCRIPT="${WORKSPACE}/12-mysql.sql"
DBNAME=nightly_qa2

cp 12.properties ${CATALINA_BASE}/sakai/sakai.properties
cd ${CATALINA_BASE}
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
    #Remove Assets
	rm -rf /var/sakai-assets/qa1-us//*

	mysql -h ${MYSQLDB} -u ${DBNAME} -p${MYSQLQA12DB} -e "drop database ${DBNAME}"
	sleep 10
	mysql -h ${MYSQLDB} -u ${DBNAME} -p${MYSQLQA12DB} -e "create database ${DBNAME} character set utf8"    
fi

bin/clean-code.sh
tar xzf /tmp/sakai$TAG.tar.gz
nohup bin/start.sh

if (( ${cleardb} == 1 )); then
    if [ -f "${DBSCRIPT}" ]; then
    	sleep 15m 
        mysql -f -h ${MYSQLDB} -u ${DBNAME} -p${MYSQLQA12DB} ${DBNAME} -e "source ${DBSCRIPT}"
    fi
fi
