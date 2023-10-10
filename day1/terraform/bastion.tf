resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "keypair" {
  key_name = "${var.NAME}-keypair"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "keypair" {
  content = tls_private_key.rsa.private_key_pem
  filename = "${aws_key_pair.keypair.key_name}.pem"
}


#icacls skills-keypair.pem /inheritance:r /deny "*S-1-1-0:(OI)(CI)(F)"
#icacls skills-keypair.pem /grant USER:R




resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  associate_with_private_ip = aws_instance.bastion.private_ip
  tags = {
    Name = "${var.NAME}-bastion-eip"
  }
}

resource "aws_security_group" "bastion" {
  name = "${var.NAME}-bastion-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "22"
    to_port = "22"
  }

  egress {
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "443"
    to_port = "443"
  }

  egress {
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "80"
    to_port = "80"
  }

  lifecycle {
    ignore_changes = [ingress, egress]
  }

  tags = {
    Name = "${var.NAME}-bastion-sg"
  }  
}

resource "aws_iam_role" "bastion" {
  name = "${var.NAME}-bastion-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${var.NAME}-bastion-profile"
  role = aws_iam_role.bastion.name
}

resource "aws_instance" "bastion" {
  instance_type = "t3.small"
  subnet_id = aws_subnet.public_a.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.bastion.id]
  iam_instance_profile = aws_iam_instance_profile.bastion.name
  key_name = aws_key_pair.keypair.key_name
  
  ami = "ami-035da6a0773842f64"

  tags = {
    Name = "${var.BASTION_NAME}"
  }

  user_data = <<-EOF
    #!/bin/bash
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    ./aws/install

    yum install -y jq curl
  EOF
}



