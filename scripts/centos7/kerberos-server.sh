#!/bin/bash

set -e
set -x

KERBEROS_HOST_ADDRESS=$(hostname)

# Kerberos principals are tightly bound to hostname and resolved DNS
# On EC2 hostname (some instances) does not match the resolved DNS
# This do not persist through restarts. Change /etc/hostname and reboot for that.
# sudo hostname $(hostname)".ec2.internal"

sudo yum install -y openldap-clients krb5-server krb5-workstation krb5-libs

# Relevant files:
# - /etc/krb5.conf
# - /var/kerberos/krb5kdc/kdc.conf
# - /var/kerberos/krb5kdc/kadm5.acl

sudo bash -c 'cat > /etc/krb5.conf' << EOF
# Configuration snippets may be placed in this directory as well
includedir /etc/krb5.conf.d/

[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 dns_lookup_realm = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true
 rdns = false
 default_realm = ANACONDA.COM
 default_ccache_name = KEYRING:persistent:%{uid}

[realms]
 ANACONDA.COM = {
  kdc = kerberos.example.com
  admin_server = kerberos.example.com
 }

[domain_realm]
 .anaconda.com = ANACONDA.COM
 anaconda.com = ANACONDA.COM
EOF

sudo sed -i.m1 's/kerberos.example.com/'`echo $KERBEROS_HOST_ADDRESS`'/' /etc/krb5.conf

sudo bash -c 'cat > /var/kerberos/krb5kdc/kdc.conf' << EOF
[kdcdefaults]
 kdc_ports = 88
 kdc_tcp_ports = 88
 max_life = 1d  
 max_renewable_life = 7d

[realms]
 ANACONDA.COM = {
  max_renewable_life = 7d 0h 0m 0s
  acl_file = /var/kerberos/krb5kdc/kadm5.acl
  dict_file = /usr/share/dict/words
  admin_keytab = /var/kerberos/krb5kdc/kadm5.keytab
  # note that aes256 is ONLY supported in Active Directory in a domain / forrest operating at a 2008 or greater functional level.
  # aes256 requires that you download and deploy the JCE Policy files for your JDK release level to provide
  # strong java encryption extension levels like AES256. Make sure to match based on the encryption configured within AD for
  # cross realm auth, note that RC4 = arcfour when comparing windows and linux enctypes
  supported_enctypes = aes256-cts:normal aes128-cts:normal arcfour-hmac:normal
  default_principal_flags = +renewable, +forwardable
 }
EOF

sudo bash -c 'cat > /var/kerberos/krb5kdc/kadm5.acl' << EOF
*/admin@ANACONDA.COM	*
EOF

# Init database
# sudo kdb5_util destroy -f
sudo kdb5_util -P anaconda create -s

# Start services
sudo service krb5kdc start
sudo service kadmin start

# Create cloudera-scm/admin principal - password: cloudera
sudo kadmin.local addprinc -pw centos centos@ANACONDA.COM
sudo kadmin.local addprinc -pw cloudera cloudera-scm/admin@ANACONDA.COM
