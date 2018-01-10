variable "key_name" {
  description = "SSH key name in your AWS account for AWS instances."
}

variable "key_path" {
  description = "Path to the private key specified by key_name."
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

variable "dsw_master" {
  description = "Launch the DSW master (1 to enable - 0 to disable)"
  default     = "0"
}

variable "dsw_nodes" {
  description = "Number DSW nodes to launch"
  default     = "00"
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
    ubuntu1404  = "ubuntu"
    centos7     = "centos"
  }
}

variable "ami" {
  description = "AWS AMI Id, if you change, make sure it is compatible with instance type, not all AMIs allow all instance types"

  default = {
    us-east-1-ubuntu1404      = "ami-fce3c696"
    us-east-2-ubuntu1404      = "ami-b7075dd2"
    us-west-1-ubuntu1404      = "ami-a9a8e4c9"
    us-west-2-ubuntu1404      = "ami-9abea4fb"
    us-east-1-centos7         = "ami-6d1c2007"
    us-east-2-centos7         = "ami-6a2d760f"
    us-west-1-centos7         = "ami-af4333cf"
  }
}

variable "instance_type" {
  description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
  default     = "m4.xlarge"
}

variable "volume_type" {
  description = "The type of volume. Can be 'standard', 'gp2', or 'io1'"
  default     = "io1"
}

variable "volume_size" {
  description = "Volume size of the CDH nodes"
  default     = "300"
}

variable "iops" {
  description = "IOPS for the disk. Only if volume_type is io1"
  default     = "1000"
}
