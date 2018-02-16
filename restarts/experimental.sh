#Most of these variables need to be defined externally (in Jenkins)
#  These include 
#  CLEAR_DB - (1/0) 
#  MYSQLDB - Host name for MySQL
#  MYSQLEXPER12DB - Password for this database

BUILD_ID=bin/startup.sh
CATALINA_BASE=/var/trunk-experimental
DBSCRIPT="${WORKSPACE}/master-mysql.sql"
DBNAME=experimental

# Copy in the sakai.properties

cp experimental.properties ${CATALINA_BASE}/sakai/sakai.properties
cd ${CATALINA_BASE}
bin/catalina.sh stop -force || true
sleep 30

#Only run this between 0 and 4AM
typeset -i chour=10#`date +"%H"`
typeset -i dow=10#`date +"%u"`
typeset -i shour=0
typeset -i ehour=4;
typeset -i dowclear=7;
typeset -i cleardb=${CLEAR_DB:-0}

if (( (${chour} >= ${shour}) && (${chour} <= ${ehour}) )); then
	#Only reset on Saturday
    echo "Dow is ${dow} clear on ${dowclear}"
	if (( ${dow} == ${dowclear} )); then
      cleardb=1
	fi
fi

if (( ${cleardb} == 1 )); then
     echo "Clearing database and assets"
     mysql -h ${MYSQLDB} -u ${DBNAME} -p${MYSQLEXPER12DB}  -e "drop database ${DBNAME}"
     sleep 5
     mysql -h ${MYSQLDB} -u ${DBNAME} -p${MYSQLEXPER12DB}  -e "create database ${DBNAME} character set utf8"
     #Remove Assets
     rm -rf /var/sakai-assets/trunk-experimental/*
fi

rm -rf work/Catalina logs/* webapps components shared/lib/ lib temp/*

tar xzf /tmp/trunkbuild.tar.gz
#From evaluation trunk build
tar zxf /tmp/evaluationbuild.tar.gz
#From gradeebook ng trunk build
#tar zxf /tmp/gradebookngbuild.tar.gz

nohup bin/startup.sh


#Run this script if we're clearing the db 5 minutes after Sakai starts up.
if (( ${cleardb} == 1 )); then
    echo ${DBSCRIPT}
    if [ -f "${DBSCRIPT}" ]; then

        sleep 15m
        mysql -f -h ${MYSQLDB} -u ${DBNAME} -p${MYSQLEXPER12DB} ${DBNAME} -e "source ${DBSCRIPT}"
    fi
fi
