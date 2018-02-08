#!/bin/bash

set -e
set -x

head_ip_address=$1

sudo apt-get update
sudo apt-get install -y cloudera-manager-daemons cloudera-manager-agent

sudo sed -i 's/server_host=localhost/server_host='"$head_ip_address"'/' /etc/cloudera-scm-agent/config.ini

sudo service cloudera-scm-agent start
