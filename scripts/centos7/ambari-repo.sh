#!/bin/bash

set -e
set -x

# Requirements
sudo yum install -y ntp
sudo systemctl enable ntpd
sudo systemctl start ntpd
sudo setenforce 0 || /bin/true
sudo iptables -F

# Repo
sudo yum install -y wget
sudo wget -nv http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.5.2.0/ambari.repo -O /etc/yum.repos.d/ambari.repo
