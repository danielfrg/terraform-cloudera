# Terraform module for Cloudera Manager

This module tries to make it a little bit easier to create a Cloudera managed cluster using Terraform.

After running this terraform module you should have Cloudera SCM agents in all the nodes
connected to a Cloudera Manager server so just have to hit "Next, next, next" a couple of times to have your cluster ready.

Note that the default configuration uses an embedded postgresql database that is not recommended for production.

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
    cdh_server = "1"
    cdh_nodes = "3"
    dsw_master = "1"
    dsw_nodes = "3"
    volume_size = "100"
}

output "cdh_server_address" {
    value = "${module.cloudera.cdh_server_address}"
}

output "dsw_master_address" {
    value = "${module.cloudera.dsw_master_address}"
}

```

```
$ terraform apply
....
Outputs:

server_address = <Public IP address>
```

Navigate to `<Public IP address>:7180` and login (user: `admin`, pass:`admin`).

Follow the multiple prompts and on `Specify hosts for your CDH cluster installation` click on `Currently Managed Hosts (X)`
and all your nodes should already be connected.

## Notes

You might need to add this to you ssh client config (`~/.ssh/config`) if the bootstrap fails for centos:

```
Host *
    ServerAliveInterval 600
```

The installation script are based on the
[Installation Path B - Installation Using Cloudera Manager Parcels or Packages](https://www.cloudera.com/documentation/enterprise/5-9-x/topics/cm_ig_install_path_b.html)
documentation

## Ambari

For ambari right now it sets up the server and you need to keep going from: `ambari-server setup` [docs](https://docs.hortonworks.com/HDPDocuments/Ambari-2.5.2.0/bk_ambari-installation/content/set_up_the_ambari_server.html)

```
module "cloudera" {
    ...

    ambari_serve = "1"
    ambari_nodes = "3"
}
```
