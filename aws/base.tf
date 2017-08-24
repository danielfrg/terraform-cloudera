resource "aws_placement_group" "cloudera" {
    name = "${var.tag_name}"
    strategy = "cluster"
}

resource "aws_security_group" "cloudera" {
    name = "${var.tag_name}"
    description = "Cloudera (${var.tag_name}) outside and maintenance traffic"

    tags {
        Name = "${var.tag_name}"
    }

    // These are for internal and external traffic
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        self = true
    }

    // CDH manager
    ingress {
        from_port   = 7180
        to_port     = 7180
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // DSW
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // This is for outbound internet access
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // These are for maintenance
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // Debug
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
