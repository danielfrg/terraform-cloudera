
resource "aws_instance" "cdh_server" {
    ami = "${lookup(var.ami, "${var.region}-${var.platform}")}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    count = "${var.cdh_server}"
    security_groups = ["${aws_security_group.cloudera.name}"]
    placement_group = "${aws_placement_group.cloudera.id}"

    root_block_device {
        volume_type = "${var.volume_type}"
        volume_size = "${var.volume_size}"
        iops = "${var.iops}"
        delete_on_termination = true
    }

    tags {
        Name = "${var.tag_name}-cdh-server"
    }

    volume_tags {
        Name = "${var.tag_name}-cdh-server"
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

    provisioner "file" {
        source = "${path.module}/../scripts/${var.platform}/server.sh"
        destination = "/tmp/server.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/server.sh",
            "/tmp/server.sh",
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

    provisioner "file" {
        source = "${path.module}/../scripts/${var.platform}/kerberos-server.sh",
        destination = "/tmp/kerberos-server.sh"
    }

    provisioner "remote-exec" {
        inline = [
          "chmod +x /tmp/kerberos-server.sh",
          "/tmp/kerberos-server.sh ${aws_instance.cdh_server.private_ip}",
        ]
    }
}

resource "aws_instance" "cdh_node" {
    ami = "${lookup(var.ami, "${var.region}-${var.platform}")}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    count = "${var.cdh_nodes}"
    security_groups = ["${aws_security_group.cloudera.name}"]
    placement_group = "${aws_placement_group.cloudera.id}"

    root_block_device {
        volume_type = "${var.volume_type}"
        volume_size = "${var.volume_size}"
        iops = "${var.iops}"
    }

    connection {
        user = "${lookup(var.user, var.platform)}"
        private_key = "${file("${var.key_path}")}"
    }

    tags {
        Name = "${var.tag_name}-node-${count.index}"
    }

    volume_tags {
        Name = "${var.tag_name}-node-${count.index}"
    }

    provisioner "remote-exec" {
        scripts = [
            "${path.module}/../scripts/${var.platform}/cloudera-repo.sh",
            "${path.module}/../scripts/${var.platform}/java.sh",
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

    provisioner "file" {
        source = "${path.module}/../scripts/${var.platform}/kerberos-node.sh",
        destination = "/tmp/kerberos-node.sh"
    }

    provisioner "remote-exec" {
        inline = [
          "chmod +x /tmp/kerberos-node.sh",
          "/tmp/kerberos-node.sh ${aws_instance.cdh_server.private_ip}",
        ]
    }
}
