
resource "aws_instance" "ambari_server" {
    ami = "${lookup(var.ami, "${var.region}-${var.platform}")}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    count = "${var.ambari_server}"
    security_groups = ["${aws_security_group.cloudera.name}"]
    placement_group = "${aws_placement_group.cloudera.id}"

    root_block_device {
        volume_type = "${var.volume_type}"
        volume_size = "${var.volume_size}"
        iops = "${var.iops}"
        delete_on_termination = true
    }

    tags {
        Name = "${var.tag_name}-ambari-server"
    }

    volume_tags {
        Name = "${var.tag_name}-ambari-server"
    }

    connection {
        user = "${lookup(var.user, var.platform)}"
        private_key = "${file("${var.key_path}")}"
    }

    provisioner "remote-exec" {
        scripts = [
            "${path.module}/../scripts/${var.platform}/ambari-repo.sh",
        ]
    }

    provisioner "file" {
        source = "${path.module}/../scripts/${var.platform}/ambari-server.sh"
        destination = "/tmp/ambari-server.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/ambari-server.sh",
            "/tmp/ambari-server.sh",
        ]
    }
}

resource "aws_instance" "ambari_node" {
    ami = "${lookup(var.ami, "${var.region}-${var.platform}")}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    count = "${var.ambari_nodes}"
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
        Name = "${var.tag_name}-ambari-node-${count.index}"
    }

    volume_tags {
        Name = "${var.tag_name}-ambari-node-${count.index}"
    }

    provisioner "remote-exec" {
        scripts = [
            "${path.module}/../scripts/${var.platform}/ambari-repo.sh",
        ]
    }
}
