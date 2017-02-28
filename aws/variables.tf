variable "platform" {
  default     = "ubuntu1404"
  description = "The OS Platform"
}

variable "user" {
  default = {
    ubuntu1404  = "ubuntu"
    centos6     = "centos"
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
    us-east-1-centos6         = "ami-57cd8732"
    us-east-2-centos6         = "ami-c299c2a7"
    us-west-2-centos6         = "ami-1255b321"
    us-east-1-centos7         = "ami-6d1c2007"
    us-east-2-centos7         = "ami-6a2d760f"
    us-west-1-centos7         = "ami-af4333cf"
  }
}

variable "key_name" {
  description = "SSH key name in your AWS account for AWS instances."
}

variable "key_path" {
  description = "Path to the private key specified by key_name."
}

variable "region" {
  default     = "us-east-1"
  description = "The region of AWS, for AMI lookups."
}

variable "servers" {
  default     = "3"
  description = "The number of Cloudera managed servers to launch."
}

variable "instance_type" {
  default     = "m4.large"
  description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
}

variable "tagName" {
  default     = "cloudera"
  description = "Name tag for the servers"
}
