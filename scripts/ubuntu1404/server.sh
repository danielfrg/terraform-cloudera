#!/bin/bash

set -e
set -x

sudo apt-get update
sudo apt-get install -y cloudera-manager-daemons cloudera-manager-server cloudera-manager-server-db-2
sudo service cloudera-scm-server-db start
sudo service cloudera-scm-server start
