#!/bin/bash

set -e
set -x

curl -s https://archive.cloudera.com/cm5/ubuntu/trusty/amd64/cm/archive.key | sudo apt-key add -
sudo curl -o /etc/apt/sources.list.d/cloudera.list https://archive.cloudera.com/cm5/ubuntu/trusty/amd64/cm/cloudera.list
sudo apt-get update
