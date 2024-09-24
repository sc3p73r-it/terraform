
//private key 
resource "tls_private_key" "ssh_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096

}

resource "local_file" "private_key" {
  filename = "${path.root}/private_key.pem"
  content  = tls_private_key.ssh_key_pair.private_key_pem

}

resource "aws_key_pair" "key_pair" {
  key_name   = "terraform_managed.pub"
  public_key = tls_private_key.ssh_key_pair.public_key_openssh
}

resource "aws_instance" "server" {
  ami                    = local.selected_ami
  subnet_id              = aws_subnet.public_subnets[0].id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.server_sg.id]
  key_name               = aws_key_pair.key_pair.id
  tags = {
    Name = "${local.vpc_name}-Server-A"
  }

}

// Security Groups
resource "aws_security_group" "server_sg" {
  vpc_id = aws_vpc.base_vpc.id
  name   = "server_sg"
  tags = {
    Name = "Server_sg"
  }

}

// Ingress Rule
resource "aws_vpc_security_group_ingress_rule" "ingress_ssh_allow" {
  security_group_id = aws_security_group.server_sg.id
  cidr_ipv4         = local.any_where
  from_port         = local.ssh
  ip_protocol       = "tcp"
  to_port           = local.ssh
}


// Egress Rule
resource "aws_vpc_security_group_egress_rule" "egress_all_allow" {
  security_group_id = aws_security_group.server_sg.id
  cidr_ipv4         = local.any_where
  ip_protocol       = local.any_protocol # semantically equivalent to all ports
}


// ec2 variable with condition

variable "Operating_System" {
  description = "Choose your OS:[ \"ubuntu\", \"redhat\", \"amazon-linux-2\" ]"
  validation {
    condition     = var.Operating_System == "ubuntu" || var.Operating_System == "redhat" || var.Operating_System == "amazon-linux-2"
    error_message = "ami not found !!!"
  }

}


// use locals

locals {
  os_to_ami = {
    "ubuntu"         = "ami-01811d4912b4ccb26"
    "redhat"         = "ami-0b748249d064044e8"
    "amazon-linux-2" = "ami-0aa097a5c0d31430a"
  }

  ssh_username = {
    "ami-01811d4912b4ccb26" = "ubuntu"
    "ami-0b748249d064044e8" = "redhat"
    "ami-0aa097a5c0d31430a" = "ec2-user"
  }

  selected_ami = lookup(local.os_to_ami, var.Operating_System, "whoami?")
}


output "ssh_command" {
  value = "ssh -i ${local_file.private_key.filename} ${lookup(local.ssh_username, local.selected_ami)}@${aws_eip.public_eip.public_ip}"
}

resource "aws_eip" "public_eip" {
  domain = "vpc"
}


resource "aws_eip_association" "binding_server_ip" {
  instance_id   = aws_instance.server.id
  allocation_id = aws_eip.public_eip.id

}