#!/bin/bash

set -e
set -x

CDH_SERVER_PRIVATE_IP=$1

sudo yum install -y cloudera-manager-daemons cloudera-manager-agent
sudo setenforce 0 || /bin/true
sudo iptables -F
sudo sed -i 's/server_host=localhost/server_host='"$CDH_SERVER_PRIVATE_IP"'/' /etc/cloudera-scm-agent/config.ini
sudo service cloudera-scm-agent start
