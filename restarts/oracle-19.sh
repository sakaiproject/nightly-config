#Most of these variables need to be defined externally (in Jenkins)
#  These include 
#  CLEAR_DB - (1/0) 
#  ORACLEDB - Host name for Oracl

BUILD_ID=bin/startup.sh
cp 19.properties /var/sakai19-oracle/sakai/sakai.properties
cd /var/sakai19-oracle
bin/stop.sh -force || true
sleep 30

#Only run this between 0 and 4AM
typeset -i chour=10#`/bin/date +"%H"`
typeset -i cday=10#`/bin/date +"%u"`

typeset -i shour=0
typeset -i ehour=5

echo "Current hour is ${chour}. Current day is ${cday}"

if (( (${chour} >= ${shour}) && (${chour} <= ${ehour}) )); then
	/usr/lib/oracle/12.1/client64/bin/sqlplus "qa19/qa19@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=${ORACLEDB})(PORT=1521))(CONNECT_DATA=(SID=ORCL)))" @/usr/local/oracle/drop-oracle-tables.sql
	#Remove Assets
	rm -rf /var/sakai-assets/qa19-oracle/*
    bin/clean-db.sh
fi

bin/clean-code.sh
# rm -rf work/Catalina logs/* webapps components shared/lib/ lib temp/* sakai/archive-unzip/*
tar xzf /tmp/sakai19x.tar.gz
nohup bin/start.sh
