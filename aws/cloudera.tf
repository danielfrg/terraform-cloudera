resource "aws_placement_group" "cluster" {
    name = "${var.group_name}"
    strategy = "cluster"
}

resource "aws_instance" "server" {
    ami = "${lookup(var.ami, "${var.region}-${var.platform}")}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    security_groups = ["${aws_security_group.cloudera.name}"]
    placement_group = "${aws_placement_group.cluster.id}"

    connection {
        user = "${lookup(var.user, var.platform)}"
        private_key = "${file("${var.key_path}")}"
    }

    tags {
        Name = "${var.tagName}-server"
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
            "/tmp/server.sh ${count.index}",
        ]
    }

    provisioner "file" {
        source = "${path.module}/../scripts/${var.platform}/agent.sh",
        destination = "/tmp/agent.sh"
    }

    provisioner "remote-exec" {
        inline = [
          "chmod +x /tmp/agent.sh",
          "/tmp/agent.sh ${aws_instance.server.private_ip}",
        ]
    }
}

resource "aws_instance" "agent" {
    ami = "${lookup(var.ami, "${var.region}-${var.platform}")}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    count = "${var.servers - 1}"
    security_groups = ["${aws_security_group.cloudera.name}"]
    placement_group = "${aws_placement_group.cluster.id}"

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
        Name = "${var.tagName}-agent-${count.index}"
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
          "/tmp/agent.sh ${aws_instance.server.private_ip}",
        ]
    }
}

resource "aws_security_group" "cloudera" {
    name = "terraform_cloudera"
    description = "Cloudera outside traffic (all open) + maintenance"

    // These are for internal and external traffic
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        self = true
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "udp"
        self = true
        cidr_blocks = ["0.0.0.0/0"]
    }

    // These are for maintenance
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // This is for outbound internet access
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
