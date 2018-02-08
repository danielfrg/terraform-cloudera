#!/bin/bash

set -e
set -x

CDH_SERVER_PRIVATE_IP=$1

sudo setenforce 0 || /bin/true
sudo iptables -F

sudo yum install -y cloudera-manager-daemons cloudera-manager-agent
sudo sed -i 's/server_host=localhost/server_host='"$CDH_SERVER_PRIVATE_IP"'/' /etc/cloudera-scm-agent/config.ini
sudo service cloudera-scm-agent start

#############
# Performance
#############

# Swappiness to 1
sudo sysctl vm.swappiness=1  # Sets at runtime
sudo bash -c "echo 'vm.swappiness = 1' >> /etc/sysctl.conf"  # Persists after reboot

# Disable Transparent Huge Page Compaction
sudo bash -c "echo never > /sys/kernel/mm/transparent_hugepage/defrag"   # At runtime
sudo bash -c "echo never > /sys/kernel/mm/transparent_hugepage/enabled"  # At runtime
sudo bash -c "echo 'echo never > /sys/kernel/mm/transparent_hugepage/defrag' >> /etc/rc.d/rc.local"   # Persists after reboot
sudo bash -c "echo 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' >> /etc/rc.d/rc.local"  # Persists after reboot
sudo chmod +x /etc/rc.d/rc.local  # Activate script
