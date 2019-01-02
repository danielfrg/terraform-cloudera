module "cloudera" {
  source = "./aws"

  tag_name       = "daniel-demo"
  platform       = "centos7"
  key_name       = "drodriguez"
  key_path       = "~/.ssh/drodriguez-product.pem"
  region         = "us-east-1"
  instance_type  = "c4.2xlarge"
  volume_size    = "500"

  cdh_server      = "1"
  cdh_nodes       = "0"
  dsw_domain      = "cdsw.product.anaconda.com"
  hosted_zone_id  = "Z3W0RIE0DYLBGE"
  dsw_master      = "1"
  dsw_nodes       = "3"
  client          = "0"
  ambari_server   = "0"
  ambari_nodes    = "0"
}

# output "cdh_server_address" {
#   value = "${module.cloudera.cdh_server_address}"
# }

# output "dsw_master_address" {
#   value = "${module.cloudera.dsw_master_address}"
# }
