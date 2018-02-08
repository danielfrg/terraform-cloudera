#!/bin/bash

set -e
set -x

DSW_MASTER_PRIVATE_IP=$1
DSW_DOMAIN=$2

sudo yum install -y cloudera-data-science-workbench

sudo bash -c 'cat > /etc/cdsw/config/cdsw.conf' << EOF
DOMAIN="?DOMAIN"
MASTER_IP="?MASTER_IP"
DOCKER_BLOCK_DEVICES="/dev/xvdb"
JAVA_HOME="/usr/java/jdk1.8.0_121-cloudera/jre"
APPLICATION_BLOCK_DEVICE="/dev/xvdc"

KUBE_TOKEN=496c1f.040be8cbb0f7dfcc
EOF

sudo sed -i.m1 's/?DOMAIN/'`echo $DSW_DOMAIN`'/' /etc/cdsw/config/cdsw.conf
sudo sed -i.m2 's/?MASTER_IP/'`echo $DSW_MASTER_PRIVATE_IP`'/' /etc/cdsw/config/cdsw.conf
