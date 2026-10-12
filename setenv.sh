export UMASK='0022'
CATALINA_PID=$CATALINA_BASE/sakai.pid

JAVA_VERSION=$("$JAVA_HOME/bin/java" -version 2>&1 | awk -F\" '/version/ {print $2}'| cut -d '.' -f 1)
echo "Enabling config for Java ${JAVA_VERSION}"

# Server mode optimizes the JVM for heavy, long-running server applications, faster JIT compilation
CATALINA_OPTS="-server" 

# Run headless with no physical display, keyboard, or mouse
CATALINA_OPTS="$CATALINA_OPTS -Djava.awt.headless=true"

# pre-allocate and map all memory pages during startup
CATALINA_OPTS="$CATALINA_OPTS -XX:+AlwaysPreTouch"

# Disable manual garbage collection calls
CATALINA_OPTS="$CATALINA_OPTS -XX:+DisableExplicitGC"

# Prefer IPv4 network addresses over IPv6
CATALINA_OPTS="$CATALINA_OPTS -Djava.net.preferIPv4Stack=true"

# Memory size
CATALINA_OPTS="$CATALINA_OPTS -Xms2g -Xmx2g"

# JDK 11 to 14
if [ "${JAVA_VERSION}" -ge 11 ] && [ "${JAVA_VERSION}" -lt 15 ]; then
    # CMS Garbage Collector
    CATALINA_OPTS="$CATALINA_OPTS -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=72"
    # Generational Sizing 1/4 to 1/3 heap size
    CATALINA_OPTS="$CATALINA_OPTS -XX:NewSize=500m -XX:MaxNewSize=500m"
    # 64 bit JVMS under 32GB use 32 bit addressing
    CATALINA_OPTS="$CATALINA_OPTS -XX:+UseCompressedOops"

    # Java Modules
    JAVA_OPTS="$JAVA_OPTS \
        --add-exports=java.base/jdk.internal.misc=ALL-UNNAMED \
        --add-exports=java.base/sun.nio.ch=ALL-UNNAMED \
        --add-exports=java.management/com.sun.jmx.mbeanserver=ALL-UNNAMED \
        --add-exports=jdk.internal.jvmstat/sun.jvmstat.monitor=ALL-UNNAMED \
        --add-exports=java.base/sun.reflect.generics.reflectiveObjects=ALL-UNNAMED \
        --add-opens=jdk.management/com.sun.management.internal=ALL-UNNAMED \
        --illegal-access=permit"

# JDK 15 to 20 
elif [ "${JAVA_VERSION}" -ge 15 ] && [ "${JAVA_VERSION}" -lt 21 ]; then
    # G1 Garbage Collector
    CATALINA_OPTS="$CATALINA_OPTS -XX:+UseG1GC"
    # Shenandoah Garbage Collector
    #CATALINA_OPTS="$CATALINA_OPTS -XX:+UseShenandoahGC"
    # Generational Sizing 1/4 to 1/3 heap size
    CATALINA_OPTS="$CATALINA_OPTS -XX:NewSize=500m -XX:MaxNewSize=500m"
    # 64 bit JVMS under 32GB use 32 bit addressing
    CATALINA_OPTS="$CATALINA_OPTS -XX:+UseCompressedOops"

    # Java Modules
    JAVA_OPTS="$JAVA_OPTS \
        --add-opens=java.base/java.io=ALL-UNNAMED \
        --add-opens=java.base/java.lang=ALL-UNNAMED \
        --add-opens=java.base/java.lang.invoke=ALL-UNNAMED \
        --add-opens=java.base/java.lang.reflect=ALL-UNNAMED \
        --add-exports=java.base/java.lang.reflect=ALL-UNNAMED \
        --add-opens=java.base/java.math=ALL-UNNAMED \
        --add-opens=java.base/java.net=ALL-UNNAMED \
        --add-opens=java.base/java.nio=ALL-UNNAMED \
        --add-opens=java.base/java.text=ALL-UNNAMED \
        --add-opens=java.base/java.time=ALL-UNNAMED \
        --add-opens=java.base/java.util=ALL-UNNAMED \
        --add-opens=java.base/java.util.concurrent=ALL-UNNAMED \
        --add-opens=java.base/java.util.concurrent.atomic=ALL-UNNAMED \
        --add-opens=java.base/java.util.concurrent.locks=ALL-UNNAMED \
        --add-opens=java.base/jdk.internal.access=ALL-UNNAMED \
        --add-opens=java.base/jdk.internal.misc=ALL-UNNAMED \
        --add-opens=java.base/sun.nio.ch=ALL-UNNAMED \
        --add-opens=java.base/sun.reflect.generics.reflectiveObjects=ALL-UNNAMED \
        --add-opens=java.base/sun.util.calendar=ALL-UNNAMED \
        --add-opens=java.desktop/java.awt.font=ALL-UNNAMED \
        --add-opens=java.desktop/javax.swing.tree=ALL-UNNAMED \
        --add-opens=java.management/com.sun.jmx.mbeanserver=ALL-UNNAMED \
        --add-opens=java.management/sun.management=ALL-UNNAMED \
        --add-opens=java.sql/java.sql=ALL-UNNAMED \
        --add-opens=jdk.internal.jvmstat/sun.jvmstat.monitor=ALL-UNNAMED \
        --add-opens=jdk.management/com.sun.management.internal=ALL-UNNAMED"

# JDK 21 and higher
elif [ "${JAVA_VERSION}" -ge 21 ]; then
    CATALINA_OPTS="$CATALINA_OPTS -XX:+UseZGC -XX:+ZGenerational"

    # Java Modules
    JAVA_OPTS="$JAVA_OPTS \
        --add-opens=java.base/java.io=ALL-UNNAMED \
        --add-opens=java.base/java.lang=ALL-UNNAMED \
        --add-opens=java.base/java.lang.invoke=ALL-UNNAMED \
        --add-opens=java.base/java.lang.reflect=ALL-UNNAMED \
        --add-exports=java.base/java.lang.reflect=ALL-UNNAMED \
        --add-opens=java.base/java.math=ALL-UNNAMED \
        --add-opens=java.base/java.net=ALL-UNNAMED \
        --add-opens=java.base/java.nio=ALL-UNNAMED \
        --add-opens=java.base/java.text=ALL-UNNAMED \
        --add-opens=java.base/java.time=ALL-UNNAMED \
        --add-opens=java.base/java.util=ALL-UNNAMED \
        --add-opens=java.base/java.util.concurrent=ALL-UNNAMED \
        --add-opens=java.base/java.util.concurrent.atomic=ALL-UNNAMED \
        --add-opens=java.base/java.util.concurrent.locks=ALL-UNNAMED \
        --add-opens=java.base/jdk.internal.access=ALL-UNNAMED \
        --add-opens=java.base/jdk.internal.misc=ALL-UNNAMED \
        --add-exports=java.base/jdk.internal.misc=ALL-UNNAMED \
        --add-opens=java.base/sun.nio.ch=ALL-UNNAMED \
        --add-exports=java.base/sun.nio.ch=ALL-UNNAMED \
        --add-opens=java.base/sun.reflect.generics.reflectiveObjects=ALL-UNNAMED \
        --add-exports=java.base/sun.reflect.generics.reflectiveObjects=ALL-UNNAMED \
        --add-opens=java.base/sun.util.calendar=ALL-UNNAMED \
        --add-opens=java.desktop/java.awt.font=ALL-UNNAMED \
        --add-opens=java.desktop/javax.swing.tree=ALL-UNNAMED \
        --add-opens=java.management/com.sun.jmx.mbeanserver=ALL-UNNAMED \
        --add-exports=java.management/com.sun.jmx.mbeanserver=ALL-UNNAMED \
        --add-opens=java.management/sun.management=ALL-UNNAMED \
        --add-opens=java.sql/java.sql=ALL-UNNAMED \
        --add-opens=jdk.internal.jvmstat/sun.jvmstat.monitor=ALL-UNNAMED \
        --add-exports=jdk.internal.jvmstat/sun.jvmstat.monitor=ALL-UNNAMED \
        --add-opens=jdk.management/com.sun.management.internal=ALL-UNNAMED \
        --add-modules=jdk.incubator.vector"
fi

# Jasper config
CATALINA_OPTS="$CATALINA_OPTS -Dorg.apache.jasper.compiler.Parser.STRICT_QUOTE_ESCAPING=false"

# Enable Sakai demo mode
CATALINA_OPTS="$CATALINA_OPTS -Dsakai.demo=true"

# Sets the http agent
CATALINA_OPTS="$CATALINA_OPTS -Dhttp.agent=Sakai"

# Timezone some examples for the U.S.:  US/Eastern, US/Central, US/Mountain, US/Pacific, US/Arizona
CATALINA_OPTS="$CATALINA_OPTS -Duser.timezone=US/Eastern"

# Sets the cookie name
CATALINA_OPTS="$CATALINA_OPTS -Dsakai.cookieName=SAKAIID"

# JMX config
#CATALINA_OPTS="$CATALINA_OPTS -Djava.rmi.server.hostname=172.31.6.159 \
#	                          -Dcom.sun.management.jmxremote.port=xxxxx \
#	                          -Dcom.sun.management.jmxremote.ssl=false \
#	                          -Dcom.sun.management.jmxremote.authenticate=false" 

# JDBC Driver MariaDB is distributed by default
if [[ $(pwd) =~ "mysql8" ]]; then
    # MySQL 8 JDBC driver
    CLASSPATH="/var/jdbc-connectors/mysql-connector-j-8.0.31.jar"
fi
