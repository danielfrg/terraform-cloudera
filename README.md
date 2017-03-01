# Terraform module for Cloudera Manager

This module tries to make it a little bit easier to create a Cloudera managed cluster using Terraform.

After running this terraform module you should have Cloudera SCM agents in all the nodes
connected to a Cloudera Manager server so just have to hit "Next, next, next" a couple of times to have your cluster ready.

Note that the default configuration uses an embedded postgresql database that is not recommended for production.

## Example

```
module "cloudera" {
    source  = "github.com/danielfrg/terrafor-cloudera/aws"

    platform = "ubuntu1404"
    key_name = "<AWS keyname>"
    key_path = "<path to the matching keypair above>"
    region = "us-east-1"
    servers = "4"
}

output "server_address" {
    value = "${module.cloudera.server_address}"
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
