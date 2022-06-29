# Capture Username and User Public IP.
data "external" "my_public_ip" {
  program = [coalesce("scripts/my_public_ip.sh")]
}

resource "aws_security_group" "bastion_host" {
  name        = "bastion_host"
  description = "SSH From ${data.external.my_public_ip.result["username"]} Public IP"
  vpc_id      = var.vpc-id

  ingress {
    description = "SSH from ${data.external.my_public_ip.result["username"]} Public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.external.my_public_ip.result["my_public_ip"]]
  }

  ingress {
    description = "Allow PING"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
  }

  egress {
    description      = "Allow Internet Out"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.project-tags, { Name = "${var.resource-name-tag}-sg" }, )
}