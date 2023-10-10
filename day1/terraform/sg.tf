resource "aws_security_group" "alb" {
  name = "${var.NAME}-alb-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "80"
    to_port = "80"
  }

  egress {
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "0"
    to_port = "0"
  }

  lifecycle {
    ignore_changes = [ingress, egress]
  }

  tags = {
    Name = "${var.NAME}-alb-sg"
  }  
}



resource "aws_security_group" "stress" {
  name = "${var.NAME}-stress-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "8080"
    to_port = "8080"
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
    Name = "${var.NAME}-stress-sg"
  }  
}

resource "aws_security_group" "product" {
  name = "${var.NAME}-product-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "8080"
    to_port = "8080"
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
    Name = "${var.NAME}-product-sg"
  }  
}