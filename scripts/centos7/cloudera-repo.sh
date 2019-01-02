#!/bin/bash

set -e
set -x

sudo yum clean all

# CDH
sudo curl -o /etc/yum.repos.d/cloudera-manager.repo https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/cloudera-manager.repo
sudo rpm --import https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/RPM-GPG-KEY-cloudera

# CDSW
sudo curl -o /etc/yum.repos.d/cloudera-cdsw.repo https://archive.cloudera.com/cdsw1/1.4.3/redhat7/yum/cloudera-cdsw.repo
sudo rpm --import https://archive.cloudera.com/cdsw1/1.4.3/redhat7/yum/RPM-GPG-KEY-cloudera

# Cloudera Director (has Java 8)
sudo curl -o /etc/yum.repos.d/cloudera-director.repo https://archive.cloudera.com/director/redhat/7/x86_64/director/cloudera-director.repo
sudo rpm --import https://archive.cloudera.com/director/redhat/7/x86_64/director/RPM-GPG-KEY-cloudera

sudo yum clean all
sudo yum repolist
