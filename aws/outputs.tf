output "cdh_server_address" {
    value = "${aws_instance.cdh_server.0.public_ip}"
}

output "dsw_master_address" {
    value = "${aws_instance.dsw_master.0.public_ip}"
}

output "ambari_server_address" {
    value = "${aws_instance.ambari_server.0.public_ip}"
}
