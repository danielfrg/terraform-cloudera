#!/bin/bash

set -e
set -x

CHD_SERVER_IP_ADDRESS=$1

sudo yum install -y cloudera-manager-daemons cloudera-manager-agent
sudo setenforce 0 || /bin/true
sudo iptables -F
sudo sed -i 's/server_host=localhost/server_host='"$CHD_SERVER_IP_ADDRESS"'/' /etc/cloudera-scm-agent/config.ini
sudo service cloudera-scm-agent start
