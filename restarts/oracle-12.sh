#Most of these variables need to be defined externally (in Jenkins)
#  These include 
#  CLEAR_DB - (1/0) 
#  ORACLEDB - Host name for Oracl

BUILD_ID=bin/startup.sh
cp 12.properties /var/sakai12-oracle/sakai/sakai.properties
cd /var/sakai12-oracle
bin/catalina.sh stop -force || true
sleep 30

#Only run this between 0 and 4AM
typeset -i chour=10#`/bin/date +"%H"`
typeset -i cday=10#`/bin/date +"%u"`

typeset -i shour=0
typeset -i ehour=5

echo "Current hour is ${chour}. Current day is ${cday}"

if (( (${chour} >= ${shour}) && (${chour} <= ${ehour}) )); then
	/usr/lib/oracle/12.1/client64/bin/sqlplus "qa12/qa12@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=${ORACLEDB})(PORT=1521))(CONNECT_DATA=(SID=ORCL)))" @/usr/local/oracle/drop-oracle-tables.sql
	#Remove Assets
	rm -rf /var/sakai-assets/qa12-oracle/*
fi

rm -rf work/Catalina logs/* webapps components shared/lib/ lib temp/* sakai/archive-unzip/*
tar xzf /tmp/sakai12x.tar.gz
nohup bin/startup.sh
