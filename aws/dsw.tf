
resource "aws_instance" "dsw_master" {
    ami = "${lookup(var.ami, "${var.region}-${var.platform}")}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    count = "${var.dsw_master}"
    security_groups = ["${aws_security_group.cloudera.name}"]
    placement_group = "${aws_placement_group.cloudera.id}"

    tags {
        Name = "${var.tag_name}-dsw-master"
    }

    volume_tags {
        Name = "${var.tag_name}-dsw-master"
    }

    root_block_device {
      volume_type           = "io1"
      volume_size           = "50"
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

    # Master only: App volume
    ebs_block_device = {
      volume_size = "500"
      volume_type = "io1"
      device_name = "/dev/xvdc"
      iops = 1000
      delete_on_termination = true
    }

    connection {
        user = "${lookup(var.user, var.platform)}"
        private_key = "${file("${var.key_path}")}"
    }

    provisioner "remote-exec" {
        scripts = [
            "${path.module}/../scripts/${var.platform}/cloudera-repo.sh",
            "${path.module}/../scripts/${var.platform}/java.sh",
        ]
    }

    provisioner "remote-exec" {
        scripts = [
            "${path.module}/../scripts/${var.platform}/dsw.sh",
        ]
    }

    provisioner "file" {
        source = "${path.module}/../scripts/${var.platform}/agent.sh",
        destination = "/tmp/agent.sh"
    }

    provisioner "remote-exec" {
        inline = [
          "chmod +x /tmp/agent.sh",
          "/tmp/agent.sh ${aws_instance.cdh_server.private_ip}",
        ]
    }
}


resource "aws_instance" "dsw_node" {
    ami = "${lookup(var.ami, "${var.region}-${var.platform}")}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    count = "${var.dsw_nodes}"
    security_groups = ["${aws_security_group.cloudera.name}"]
    placement_group = "${aws_placement_group.cloudera.id}"

    tags {
        Name = "${var.tag_name}-dsw-node-${count.index}"
    }

    volume_tags {
        Name = "${var.tag_name}-dsw-node-${count.index}"
    }

    root_block_device {
      volume_type           = "io1"
      volume_size           = "50"
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

    connection {
        user = "${lookup(var.user, var.platform)}"
        private_key = "${file("${var.key_path}")}"
    }

    provisioner "remote-exec" {
        scripts = [
            "${path.module}/../scripts/${var.platform}/cloudera-repo.sh",
            "${path.module}/../scripts/${var.platform}/java.sh",
        ]
    }

    provisioner "remote-exec" {
        scripts = [
            "${path.module}/../scripts/${var.platform}/dsw.sh",
        ]
    }

    provisioner "file" {
        source = "${path.module}/../scripts/${var.platform}/agent.sh",
        destination = "/tmp/agent.sh"
    }

    provisioner "remote-exec" {
        inline = [
          "chmod +x /tmp/agent.sh",
          "/tmp/agent.sh ${aws_instance.cdh_server.private_ip}",
        ]
    }
}
