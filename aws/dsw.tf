resource "aws_instance" "dsw_master" {
  ami             = "${lookup(var.ami, "${var.region}-${var.platform}")}"
  instance_type   = "${var.instance_type}"
  key_name        = "${var.key_name}"
  count           = "${var.dsw_master}"
  security_groups = ["${aws_security_group.cloudera.name}"]
  placement_group = "${aws_placement_group.cloudera.id}"

  root_block_device {
    volume_type           = "io1"
    volume_size           = "100"
    iops                  = 1000
    delete_on_termination = true
  }

  # Docker volume
  ebs_block_device = {
    volume_type           = "io1"
    volume_size           = "500"
    device_name           = "/dev/xvdb"
    iops                  = 1000
    delete_on_termination = true
  }

  # App volume (Master only)
  ebs_block_device = {
    volume_size           = "500"
    volume_type           = "io1"
    device_name           = "/dev/xvdc"
    iops                  = 1000
    delete_on_termination = true
  }

  tags {
    Name = "${var.tag_name}-dsw-master"
  }

  volume_tags {
    Name = "${var.tag_name}-dsw-master"
  }

  connection {
    user        = "${lookup(var.user, var.platform)}"
    private_key = "${file("${var.key_path}")}"
  }

  provisioner "remote-exec" {
    scripts = [
      "${path.module}/../scripts/${var.platform}/cloudera-repo.sh",
      "${path.module}/../scripts/${var.platform}/java.sh",
    ]
  }

  provisioner "file" {
    source      = "${path.module}/../scripts/${var.platform}/cdh-agent.sh"
    destination = "/tmp/cdh-agent.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/cdh-agent.sh",
      "/tmp/cdh-agent.sh ${aws_instance.cdh_server.private_ip}",
    ]
  }

  provisioner "file" {
    source      = "${path.module}/../scripts/${var.platform}/kerberos-node.sh"
    destination = "/tmp/kerberos-node.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/kerberos-node.sh",
      "/tmp/kerberos-node.sh ${aws_instance.cdh_server.private_ip}",
    ]
  }

  provisioner "file" {
    source      = "${path.module}/../scripts/${var.platform}/cdsw.sh"
    destination = "/tmp/cdsw.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/cdsw.sh",
      "/tmp/cdsw.sh ${aws_instance.dsw_master.private_ip} ${var.dsw_domain}",
    ]
  }
}

resource "aws_instance" "dsw_node" {
  ami             = "${lookup(var.ami, "${var.region}-${var.platform}")}"
  instance_type   = "${var.instance_type}"
  key_name        = "${var.key_name}"
  count           = "${var.dsw_nodes}"
  security_groups = ["${aws_security_group.cloudera.name}"]
  placement_group = "${aws_placement_group.cloudera.id}"

  root_block_device {
    volume_type           = "io1"
    volume_size           = "100"
    iops                  = 1000
    delete_on_termination = true
  }

  # Docker volume
  ebs_block_device = {
    volume_type           = "io1"
    volume_size           = "500"
    device_name           = "/dev/xvdb"
    iops                  = 1000
    delete_on_termination = true
  }

  tags {
    Name = "${var.tag_name}-dsw-node-${count.index}"
  }

  volume_tags {
    Name = "${var.tag_name}-dsw-node-${count.index}"
  }

  connection {
    user        = "${lookup(var.user, var.platform)}"
    private_key = "${file("${var.key_path}")}"
  }

  provisioner "remote-exec" {
    scripts = [
      "${path.module}/../scripts/${var.platform}/cloudera-repo.sh",
      "${path.module}/../scripts/${var.platform}/java.sh",
    ]
  }

  provisioner "file" {
    source      = "${path.module}/../scripts/${var.platform}/cdh-agent.sh"
    destination = "/tmp/cdh-agent.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/cdh-agent.sh",
      "/tmp/cdh-agent.sh ${aws_instance.cdh_server.private_ip}",
    ]
  }

  provisioner "file" {
    source      = "${path.module}/../scripts/${var.platform}/kerberos-node.sh"
    destination = "/tmp/kerberos-node.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/kerberos-node.sh",
      "/tmp/kerberos-node.sh ${aws_instance.cdh_server.private_ip}",
    ]
  }

  provisioner "file" {
    source      = "${path.module}/../scripts/${var.platform}/cdsw.sh"
    destination = "/tmp/cdsw.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/cdsw.sh",
      "/tmp/cdsw.sh ${aws_instance.dsw_master.private_ip} ${var.dsw_domain}",
    ]
  }
}

resource "aws_eip" "lb" {
  instance = "${aws_instance.dsw_master.id}"

  #   vpc      = true

  tags {
    Name = "${var.tag_name}-dsw-master"
  }
}

resource "aws_route53_record" "master-A-record" {
  zone_id = "${var.hosted_zone_id}"
  name    = "${var.dsw_domain}"
  type    = "A"
  ttl     = "30"
  records = ["${aws_eip.lb.public_ip}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "wildcard-A-record" {
  zone_id = "${var.hosted_zone_id}"
  name    = "*.${var.dsw_domain}"
  type    = "A"
  ttl     = "30"
  records = ["${aws_eip.lb.public_ip}"]

  lifecycle {
    create_before_destroy = true
  }
}
