variable "key_name" {
  description = "SSH key name in your AWS account for AWS instances."
}

variable "key_path" {
  description = "Path to the private key specified by key_name."
}

variable "hosted_zone_id" {
  description = "Route 53 Hosted Zone ID"
}

# Optional

variable "tag_name" {
  description = "Prefix for all resources"
  default     = "cloudera"
}

variable "cdh_server" {
  description = "Launch the CDH server (1 to enable - 0 to disable)"
  default     = "1"
}

variable "cdh_nodes" {
  description = "Number of CDH nodes to launch"
  default     = "3"
}

variable "client" {
  description = "Launch a client node (1 to enable - 0 to disable)"
  default     = "0"
}

variable "dsw_master" {
  description = "Launch the DSW master (1 to enable - 0 to disable)"
  default     = "0"
}

variable "dsw_nodes" {
  description = "Number DSW nodes to launch"
  default     = "0"
}

variable "dsw_domain" {
  description = "Domain used for dsw"
  default     = "demo.cloudera.com"
}

variable "ambari_server" {
  description = "Launch the Ambari master (1 to enable - 0 to disable)"
  default     = "0"
}

variable "ambari_nodes" {
  description = "Number Ambari nodes to launch"
  default     = "0"
}

variable "region" {
  description = "The region of AWS, for AMI lookups."
  default     = "us-east-1"
}

variable "platform" {
  description = "The OS Platform (centos7 or ubuntu1404)"
  default     = "centos7"
}

variable "user" {
  default = {
    ubuntu1404 = "ubuntu"
    centos7    = "centos"
  }
}

variable "ami" {
  description = "AWS AMI Id, if you change, make sure it is compatible with instance type, not all AMIs allow all instance types"

  default = {
    us-east-1-centos7 = "ami-9887c6e7"

    # Need to update those
    # us-east-2-centos7 = "ami-e1496384"
    # us-west-1-centos7 = "ami-65e0e305"
    # us-west-2-centos7 = "ami-a042f4d8"
  }
}

variable "instance_type" {
  description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
  default     = "c4.2xlarge"
}

variable "volume_type" {
  description = "The type of volume. Can be 'standard', 'gp2', or 'io1'"
  default     = "io1"
}

variable "volume_size" {
  description = "Volume size of the CDH nodes"
  default     = "500"
}

variable "iops" {
  description = "IOPS for the disk. Only if volume_type is io1"
  default     = "1000"
}
