#!/bin/bash

set -e
set -x

# CDH
sudo rpm --import https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/RPM-GPG-KEY-cloudera
sudo curl -o /etc/yum.repos.d/cloudera-manager.repo https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/cloudera-manager.repo

# CDSW
sudo rpm --import https://archive.cloudera.com/cdsw/1/redhat/7/x86_64/cdsw/RPM-GPG-KEY-cloudera
sudo curl -o /etc/yum.repos.d/cloudera-cdsw.repo https://archive.cloudera.com/cdsw/1/redhat/7/x86_64/cdsw/cloudera-cdsw.repo

# Cloudera Director (has Java 8)
sudo rpm --import https://archive.cloudera.com/director/redhat/7/x86_64/director/RPM-GPG-KEY-cloudera
sudo curl -o /etc/yum.repos.d/cloudera-director.repo https://archive.cloudera.com/director/redhat/7/x86_64/director/cloudera-director.repo
