#!/bin/bash

set -e
set -x

# Just in case
sudo yum remove --assumeyes *openjdk*

# This one comes from cloudera repos
sudo yum install -y oracle-j2sdk1.8

# Manual install is also possible:
# rpm -ivh "https://archive.cloudera.com/director/redhat/7/x86_64/director/2.7.0/RPMS/x86_64/oracle-j2sdk1.8-1.8.0+update121-1.x86_64.rpm"
