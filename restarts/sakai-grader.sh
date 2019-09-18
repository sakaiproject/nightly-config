#Most of these variables need to be defined externally (in Jenkins)
#  These include 
#  CLEAR_DB - (1/0) 
#  MYSQLDB - Host name for MySQL
#  MYSQLGRADERDB - Password for this database

BUILD_ID=bin/startup.sh
CATALINA_BASE=/var/sakai-grader-mysql
DBNAME=nightly_grader

cp 19.properties ${CATALINA_BASE}/sakai/sakai.properties
cd ${CATALINA_BASE}
bin/stop.sh -force || true
sleep 30

if (( ${cleardb} == 1 )); then
    echo "Clearing database and assets"
    bin/clean-db.sh
	mysql -h ${MYSQLDB} -u ${DBNAME} -p${MYSQLGRADERDB} -e "drop database ${DBNAME}"
	sleep 10
	mysql -h ${MYSQLDB} -u ${DBNAME} -p${MYSQLGRADERDB} -e "create database ${DBNAME} character set utf8"    
fi

bin/clean-code.sh
tar xzf /tmp/sakai-grader-mysql.tar.gz
nohup bin/start.sh
