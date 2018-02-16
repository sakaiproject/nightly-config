#Most of these variables need to be defined externally (in Jenkins)
#  These include 
#  CLEAR_DB - (1/0) 
#  MYSQLDB - Host name for MySQL
#  MYSQLQA11DB - Password for this database

BUILD_ID=bin/startup.sh
DBNAME=nightly_qa11

cp 11.properties /var/sakai11-mysql/sakai/sakai.properties
cd /var/sakai11-mysql
bin/catalina.sh stop -force || true
sleep 30

#Only run this between 0 and 4AM
typeset -i chour=10#`/bin/date +"%H"`
typeset -i cday=10#`/bin/date +"%u"`

typeset -i shour=0
typeset -i ehour=4
typeset -i cleardb=${CLEAR_DB:-0}

echo "Current hour is ${chour}. Current day is ${cday}"

if (( (${chour} >= ${shour}) && (${chour} <= ${ehour}) )); then
	cleardb=1
fi

if (( ${cleardb} == 1 )); then 
	#Remove Assets
	rm -rf /var/sakai-assets/sakaiqa11-mysql/*

	mysql -h ${MYSQLDB} -u ${DBNAME} -p${MYSQLQA11DB} -e "drop database ${DBNAME}"
	sleep 10
	mysql -h ${MYSQLDB} -u ${DBNAME} -p${MYSQLQA11DB} -e "create database ${DBNAME} character set utf8"
fi

rm -rf work/Catalina logs/* webapps components shared/lib/ common/lib/sakai* lib temp/*
tar xzf /tmp/sakai11x.tar.gz
nohup bin/startup.sh
