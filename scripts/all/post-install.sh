#!/bin/bash

set -e
set -x

#######################################
# As HDFS user
#######################################

sudo su hdfs
kinit hdfs # password: hdfs

hdfs dfs -mkdir /user/centos/
hdfs dfs -mkdir /user/daniel/
hdfs dfs -mkdir /user/christine/
hdfs dfs -mkdir /user/kris/
hdfs dfs -mkdir /user/ben/
hdfs dfs -chown centos:centos /user/centos/
hdfs dfs -chown daniel:daniel /user/daniel/
hdfs dfs -chown christine:christine /user/christine/
hdfs dfs -chown kris:kris /user/kris/
hdfs dfs -chown ben:ben /user/ben/

#######################################
# As centos user
#######################################

# Hive data
curl -O https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data

hive -e "SHOW TABLES;"
hive -e "CREATE TABLE iris (sepal_len FLOAT, sepal_width FLOAT, petal_len FLOAT, petal_width FLOAT, response STRING) row format delimited fields terminated by ',';"
hive -e "LOAD DATA LOCAL INPATH 'iris.data' into table iris;"
hive -e "SELECT count(*) FROM iris;"
