#Most of these variables need to be defined externally (in Jenkins)
#  These include 
#  CLEAR_DB - (1/0) 
#  MYSQLDB - Host name for MySQL
#  MYSQLQA10DB - Password for this database

BUILD_ID=bin/startup.sh
DBNAME=nightly_qa10

cp 10.properties /var/sakai10-mysql/sakai/sakai.properties
cd /var/sakai10-mysql
bin/catalina.sh stop -force || true
sleep 30

#Only run this between 0 and 4AM
typeset -i chour=10#`/bin/date +"%H"`
typeset -i cday=10#`/bin/date +"%u"`

typeset -i shour=0
typeset -i ehour=4

echo "Current hour is ${chour}. Current day is ${cday}"

if (( (${chour} >= ${shour}) && (${chour} <= ${ehour}) )); then
	#Remove Assets 
	echo "Clearing database and assets"
	rm -rf /var/sakai-assets/qa10-mysql/*

	mysql -h ${MYSQLDB} -u ${DBNAME} -p${MYSQLQA10DB} -e "drop database ${DBNAME}"
	sleep 5
	mysql -h ${MYSQLDB} -u ${DBNAME} -p${MYSQLQA10DB} -e "create database ${DBNAME} character set utf8"
fi
rm -rf work/Catalina logs/* webapps components shared/lib/ common/lib/sakai* temp/*

tar xzf /tmp/sakai10x.tar.gz
nohup bin/startup.sh
