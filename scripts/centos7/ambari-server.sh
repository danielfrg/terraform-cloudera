#!/bin/bash

set -e
set -x

sudo yum install -y ambari-server
sudo ambari-server setup --silent
sudo ambari-server start
