#!/bin/bash

set -e
set -x

sudo yum install -y cloudera-manager-daemons cloudera-manager-server cloudera-manager-server-db-2
sudo setenforce 0 || /bin/true
sudo iptables -F
sudo service cloudera-scm-server-db start
sudo service cloudera-scm-server start
