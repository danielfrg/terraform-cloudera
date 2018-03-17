#!/bin/bash

set -e
set -x

LIVY_VERSION=0.5.0-incubating
LIVY_HOME=/home/livy/livy-$LIVY_VERSION-bin

##

sudo useradd -m -p $(echo livy | openssl passwd -1 -stdin) livy
sudo usermod -aG wheel livy  # This only works on centos

sudo -u livy -i <<EOF
# echo $LIVY_VERSION

# curl -O http://mirrors.advancedhosters.com/apache/incubator/livy/$LIVY_VERSION/livy-$LIVY_VERSION-bin.zip
# unzip livy-$LIVY_VERSION-bin.zip

# mkdir -p $LIVY_HOME/logs

#######################################
# Conf files
#######################################

cat >$LIVY_HOME/conf/livy.conf <<EOL
livy.server.port = 8998
# What spark master Livy sessions should use: yarn or yarn-cluster
livy.spark.master = yarn
# What spark deploy mode Livy sessions should use: client or cluster
livy.spark.deployMode = cluster

#######################################
# Kerberos stuff
#######################################

# livy.server.auth.type = kerberos
# livy.impersonation.enabled = true

# livy.server.launch.kerberos.principal = livy/$HOSTNAME@ANACONDA.COM
# livy.server.launch.kerberos.keytab = /etc/security/livy.keytab
# livy.server.auth.kerberos.principal = HTTP/$HOSTNAME@ANACONDA.COM
# livy.server.auth.kerberos.keytab = /etc/security/httplivy.keytab

# livy.server.access_control.enabled = true
# livy.server.access_control.users = livy,hdfs,zeppelin
# livy.superusers = livy,hdfs,zeppelin

EOL

cat >$LIVY_HOME/conf/livy-env.sh <<EOL
JAVA_HOME=/usr/java/jdk1.8.0_121-cloudera/jre/
SPARK_HOME=/opt/cloudera/parcels/CDH/lib/spark/ 
HADOOP_HOME=/etc/hadoop/
HADOOP_CONF_DIR=/etc/hadoop/conf

EOL

cat >$LIVY_HOME/conf/log4j.properties <<EOL
log4j.rootCategory=DEBUG, console
log4j.appender.console=org.apache.log4j.ConsoleAppender
log4j.appender.console.target=System.err
log4j.appender.console.layout=org.apache.log4j.PatternLayout
log4j.appender.console.layout.ConversionPattern=%d{yy/MM/dd HH:mm:ss} %p %c{1}: %m%n

log4j.logger.org.eclipse.jetty=WARN

EOL

EOF
