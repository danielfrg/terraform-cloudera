#!/bin/bash

set -e
set -x

sudo curl -o /etc/yum.repos.d/cloudera-manager.repo https://archive.cloudera.com/cm5/redhat/6/x86_64/cm/cloudera-manager.repo
