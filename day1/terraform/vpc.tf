resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.NAME}-vpc"
  }
}

// --- public

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.NAME}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.NAME}-pub-rt"
  }
}

resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}

resource "aws_subnet" "public_a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.NAME}-pub-a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.NAME}-pub-b"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.NAME}-pub-c"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}

// -- private

resource "aws_eip" "private_a" {
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "${var.NAME}-nat-eip-a"
  }
}

resource "aws_eip" "private_b" {
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "${var.NAME}-nat-eip-b"
  }
}

resource "aws_eip" "private_c" {
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "${var.NAME}-nat-eip-c"
  }
}

resource "aws_nat_gateway" "private_a" {
  depends_on = [aws_internet_gateway.main]

  allocation_id = aws_eip.private_a.id
  subnet_id = aws_subnet.public_a.id

  tags = {
    Name = "${var.NAME}-nat-a"
  }
}

resource "aws_nat_gateway" "private_b" {
  depends_on = [aws_internet_gateway.main]

  allocation_id = aws_eip.private_b.id
  subnet_id = aws_subnet.public_b.id

  tags = {
    Name = "${var.NAME}-nat-b"
  }
}

resource "aws_nat_gateway" "private_c" {
  depends_on = [aws_internet_gateway.main]

  allocation_id = aws_eip.private_c.id
  subnet_id = aws_subnet.public_c.id

  tags = {
    Name = "${var.NAME}-nat-c"
  }
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.NAME}-priv-a-rt"
  }
}

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.NAME}-priv-b-rt"
  }
}

resource "aws_route_table" "private_c" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.NAME}-priv-c-rt"
  }
}

resource "aws_route" "private_a" {
  route_table_id = aws_route_table.private_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.private_a.id
}

resource "aws_route" "private_b" {
  route_table_id = aws_route_table.private_b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.private_b.id
}

resource "aws_route" "private_c" {
  route_table_id = aws_route_table.private_c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.private_c.id
}

resource "aws_subnet" "private_a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.50.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "${var.NAME}-priv-a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.51.0/24"
  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "${var.NAME}-priv-b"
  }
}

resource "aws_subnet" "private_c" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.52.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "${var.NAME}-priv-c"
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_b.id
}

resource "aws_route_table_association" "private_c" {
  subnet_id = aws_subnet.private_c.id
  route_table_id = aws_route_table.private_c.id
}



# --- protected

resource "aws_subnet" "protected_a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.100.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "${var.NAME}-protected-a"
  }
}

resource "aws_subnet" "protected_b" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.101.0/24"
  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "${var.NAME}-protected-b"
  }
}

resource "aws_subnet" "protected_c" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.102.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "${var.NAME}-protected-c"
  }
}












### flow log





resource "aws_flow_log" "flowlog" {
  iam_role_arn    = aws_iam_role.flowlog.arn
  log_destination = aws_cloudwatch_log_group.flowlog.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id

  tags = {
    Name = "${var.NAME}-flow-log"
  }
}

resource "aws_cloudwatch_log_group" "flowlog" {
  name = "flowlog"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "flowlog" {
  name               = "flowlog"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "flowlog" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "flowlog" {
  name   = "flowlog"
  role   = aws_iam_role.flowlog.id
  policy = data.aws_iam_policy_document.flowlog.json
}









#endpoint




# resource "aws_security_group" "endpoints" {
#   name = "${var.NAME}-endpoint-sg"
#   vpc_id = aws_vpc.main.id

#   ingress {
#     protocol = "TCP"
#     security_groups = [
#       aws_security_group.product.id,
#       aws_security_group.stress.id
#     ]
#     from_port = "443"
#     to_port = "443"
#   }

#   egress {
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#     from_port = "0"
#     to_port = "0"
#   }

#   lifecycle {
#     ignore_changes = [ingress, egress]
#   }

#   tags = {
#     Name = "${var.NAME}-endpoint-sg"
#   }  
# }

# resource "aws_vpc_endpoint" "s3" {
#   vpc_id       = aws_vpc.main.id
#   service_name = "com.amazonaws.ap-northeast-2.s3"

#   route_table_ids = [
#     aws_route_table.private_a.id,
#     aws_route_table.private_b.id,
#     aws_route_table.private_c.id,
#     aws_route_table.private_a.id,
#     aws_route_table.public.id
#   ]
#   tags = {
#     Name = "${var.NAME}-s3-endpoint"
#   }  
# }

# resource "aws_vpc_endpoint" "sts" {
#   vpc_id            = aws_vpc.main.id
#   service_name      = "com.amazonaws.ap-northeast-2.sts"
#   vpc_endpoint_type = "Interface"

#   security_group_ids = [
#     aws_security_group.endpoints.id,
#   ]

#   subnet_ids = [
#     aws_subnet.private_a.id,
#     aws_subnet.private_b.id,
#     aws_subnet.private_c.id
#   ]

#   private_dns_enabled = true

#   tags = {
#     Name = "${var.NAME}-sts-endpoint"
#   }  
# }

# resource "aws_vpc_endpoint" "ec2" {
#   vpc_id            = aws_vpc.main.id
#   service_name      = "com.amazonaws.ap-northeast-2.ec2"
#   vpc_endpoint_type = "Interface"

#   security_group_ids = [
#     aws_security_group.endpoints.id,
#   ]

#   subnet_ids = [
#     aws_subnet.private_a.id,
#     aws_subnet.private_b.id,
#     aws_subnet.private_c.id
#   ]

#   private_dns_enabled = true

#   tags = {
#     Name = "${var.NAME}-ec2-endpoint"
#   }  
# }

# resource "aws_vpc_endpoint" "secretsmanager" {
#   vpc_id            = aws_vpc.main.id
#   service_name      = "com.amazonaws.ap-northeast-2.secretsmanager"
#   vpc_endpoint_type = "Interface"

#   security_group_ids = [
#     aws_security_group.endpoints.id,
#   ]

#   subnet_ids = [
#     aws_subnet.private_a.id,
#     aws_subnet.private_b.id,
#     aws_subnet.private_c.id
#   ]

#   private_dns_enabled = true
#   tags = {
#     Name = "${var.NAME}-secretsmanager-endpoint"
#   }  
# }

# resource "aws_vpc_endpoint" "ecr-api" {
#   vpc_id            = aws_vpc.main.id
#   service_name      = "com.amazonaws.ap-northeast-2.ecr.api"
#   vpc_endpoint_type = "Interface"

#   security_group_ids = [
#     aws_security_group.endpoints.id,
#   ]

#   subnet_ids = [
#     aws_subnet.private_a.id,
#     aws_subnet.private_b.id,
#     aws_subnet.private_c.id
#   ]

#   private_dns_enabled = true
#   tags = {
#     Name = "${var.NAME}-ecr-api-endpoint"
#   }  
# }

# resource "aws_vpc_endpoint" "ecr-dkr" {
#   vpc_id            = aws_vpc.main.id
#   service_name      = "com.amazonaws.ap-northeast-2.ecr.dkr"
#   vpc_endpoint_type = "Interface"

#   security_group_ids = [
#     aws_security_group.endpoints.id,
#   ]

#   subnet_ids = [
#     aws_subnet.private_a.id,
#     aws_subnet.private_b.id,
#     aws_subnet.private_c.id
#   ]

#   private_dns_enabled = true
#   tags = {
#     Name = "${var.NAME}-ecr-dkr-endpoint"
#   }  
# }

# resource "aws_vpc_endpoint" "ecs" {
#   vpc_id            = aws_vpc.main.id
#   service_name      = "com.amazonaws.ap-northeast-2.ecs"
#   vpc_endpoint_type = "Interface"

#   security_group_ids = [
#     aws_security_group.endpoints.id,
#   ]

#   subnet_ids = [
#     aws_subnet.private_a.id,
#     aws_subnet.private_b.id,
#     aws_subnet.private_c.id
#   ]

#   private_dns_enabled = true
#   tags = {
#     Name = "${var.NAME}-ecs-endpoint"
#   }  
# }

# resource "aws_vpc_endpoint" "ecs-agent" {
#   vpc_id            = aws_vpc.main.id
#   service_name      = "com.amazonaws.ap-northeast-2.ecs-agent"
#   vpc_endpoint_type = "Interface"

#   security_group_ids = [
#     aws_security_group.endpoints.id,
#   ]

#   subnet_ids = [
#     aws_subnet.private_a.id,
#     aws_subnet.private_b.id,
#     aws_subnet.private_c.id
#   ]

#   private_dns_enabled = true
# tags = {
#     Name = "${var.NAME}-ecs-agent-endpoint"
#   }  
# }

# resource "aws_vpc_endpoint" "ecs-telemetry" {
#   vpc_id            = aws_vpc.main.id
#   service_name      = "com.amazonaws.ap-northeast-2.ecs-telemetry"
#   vpc_endpoint_type = "Interface"

#   security_group_ids = [
#     aws_security_group.endpoints.id,
#   ]
   
#   subnet_ids = [
#     aws_subnet.private_a.id,
#     aws_subnet.private_b.id,
#     aws_subnet.private_c.id
#   ]

#   private_dns_enabled = true
#   tags = {
#     Name = "${var.NAME}-ecs-telemetry-endpoint"
#   }  
# }

# resource "aws_vpc_endpoint" "cloudwatchlogs" {
#   vpc_id            = aws_vpc.main.id
#   service_name      = "com.amazonaws.ap-northeast-2.logs"
#   vpc_endpoint_type = "Interface"

#   security_group_ids = [
#     aws_security_group.endpoints.id,
#   ]

#   subnet_ids = [
#     aws_subnet.private_a.id,
#     aws_subnet.private_b.id,
#     aws_subnet.private_c.id
#   ]

#   private_dns_enabled = true
#   tags = {
#     Name = "${var.NAME}-cloudwatchlogs-endpoint"
#   }  
# }

