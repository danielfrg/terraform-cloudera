# Terraform module for Cloudera Manager

This module tries to make it a little bit easier to create a Cloudera managed cluster using Terraform.

After running this terraform module you should have Cloudera SCM agents in all the nodes
connected to a Cloudera Manager server so just have to hit "Next, next, next" a couple of times to have your cluster ready.

## Example

```
module "cloudera" {
    source  = "github.com/danielfrg/terrafor-cloudera/aws"

    tag_name = "cloudera"
    platform = "centos7"
    key_name = "<keypair>"
    key_path = "~/.ssh/<keypair>.pem"
    region = "us-east-1"
    instance_type = "c4.2xlarge"
    volume_size = "100"

    # Instances to be created
    client = "1"  # 1 or 0
    cdh_server = "1"  # 1 or 0
    cdh_nodes = "3"   # 0 or more
    dsw_master = "0"  # 1 or 0
    dsw_nodes = "0"   # 0 or more
    ambari_server = "0"  # 1 or 0
    ambari_nodes = "0"   # 0 or more
}

output "cdh_server_address" {
    value = "${module.cloudera.cdh_server_address}"
}

output "cdh_server_address" {
    value = "${aws_instance.cdh_server.0.public_ip}"
}

# output "dsw_master_address" {
#     value = "${aws_instance.dsw_master.0.public_ip}"
# }

# output "ambari_server_address" {
#     value = "${aws_instance.ambari_server.0.public_ip}"
# }
```

```
$ terraform apply
....
Outputs:

cdh_server_address = <Public IP address>
dsw_master_address = <Public IP address>
ambari_server_address = <Public IP address>
```

Navigate to `<Public IP address>:7180` and login (user: `admin`, pass:`admin`).

Follow the multiple prompts and on `Specify hosts for your CDH cluster installation` click on `Currently Managed Hosts (X)`
and all your nodes should already be connected.

## DSW

This option will create special nodes for DSW. Basically instances with the correct EBS volumes that are required by DSW:
- 1 master:
  - Docker: `/dev/xvdb`
  - App volume: `/dev/xvdc`
- 0-X nodes: 2 mounts
  - Docker: `/dev/xvdb`

You need to configure DNS manually to point to the DSW domain.

### Packages

DSW packages are installed in all the DSW nodes.
Before installing DSW do the regular Cloudera Manager install and in the nodes for DSW select the roles:
- HDFS Gateway
- YARN Gateway
- Spark2 Gateway

Config file `/etc/cdsw/config/cdsw.conf` is configured automatically but you should double-check:
1. Domain should
2. Private IP address
3. Paths of mounts for docker and application storage (on the master)

In the master node run `sudo cdsw init`.

In the worker nodes:
1.  Delete the `APPLICATION_BLOCK_DEVICE` from `/etc/cdsw/config/cdsw.conf`
1. `sudo mkdir /var/lib/cdsw`
1. `sudo cdsw join`

### Parcel

Prerequisites:
1. Configure `JAVA_HOME` in CDH (Hosts > Configuration > JAVA_HOME) to `/usr/java/jdk1.8.0_121-cloudera/jre`

After terraform finishes go over the Cloudera Manager process and in the role selection 
use the DSW nodes only as Gateway.

CSD for Spark2 and Cloudera Data Science Workbench but you need to install the services.

After you install CDH:
1. Install Spark2 service
2. Install DSW service, you will need:
    1. Create DNS entries for the master node. `terraform output` will show you this value
    2. Private IP of master
    3. Docker volume: `/dev/xvdb`

## Kerberos

For CDH (and DSW) the Kerberos server is installed in the CDH server node and client libraries in the other nodes.
The `krb5.conf` file is automatically configured to point to the Kerberos server.

Multiple principals are created:

- `cloudera-scm/admin@ANACONDA.COM` - PW: `cloudera-scm`
- `centos@ANACONDA.COM` - PW: `centos`
- `daniel@ANACONDA.COM` - PW: `daniel`
- `christine@ANACONDA.COM` - PW: `christine`
- `kris@ANACONDA.COM` - PW: `kris`

After terraform finishes you can ssh into any node and `kinit` as the `centos` user.

On Cloudera Manager:
- Security > Enable Kerberos.
  - Follow the Cloudera Manager to finish setting up the CDH cluster with Kerberos.
- `KDC Server host` and `KDC Admin server host` is the internal ip of the CDH server.
- Use the `cloudera-scm/admin` principal (pass: `cloudera-scm`) and 

## Ambari

For ambari right now it only sets up the server and you need to keep going from: `ambari-server setup` [docs](https://docs.hortonworks.com/HDPDocuments/Ambari-2.5.2.0/bk_ambari-installation/content/set_up_the_ambari_server.html)

Basically you need to get the ip address of the nodes that are create for ambari and follow the wizard.

## Notes

You might need to add this to you ssh client config (`~/.ssh/config`) if the bootstrap fails for centos:

```
Host *
    ServerAliveInterval 600
```

The installation script are based on the
[Installation Path B - Installation Using Cloudera Manager Parcels or Packages](https://www.cloudera.com/documentation/enterprise/5-9-x/topics/cm_ig_install_path_b.html)
documentation
