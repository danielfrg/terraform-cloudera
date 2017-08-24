#!/bin/bash

set -e
set -x

# CDH
sudo curl -o /etc/yum.repos.d/cloudera-manager.repo https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/cloudera-manager.repo

# CDSW
sudo rpm --import https://archive.cloudera.com/cdsw/1/redhat/7/x86_64/cdsw/RPM-GPG-KEY-cloudera
sudo curl -o /etc/yum.repos.d/cloudera-cdsw.repo https://archive.cloudera.com/cdsw/1/redhat/7/x86_64/cdsw/cloudera-cdsw.repo
