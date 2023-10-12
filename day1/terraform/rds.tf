resource "aws_security_group" "db_sg" {
  name        = "${var.NAME}-db-sg"
  description = "Allow database traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "3306"
    to_port = "3306"
  }


  lifecycle {
    ignore_changes = [
      ingress
    ]
  }

  tags = {
    Name = "${var.NAME}-db-sg"
  }  
}


resource "aws_db_subnet_group" "db_subnet_group" {
  name = "${var.NAME}-db-subnet-group"
  subnet_ids = [
    aws_subnet.protected_a.id,
    aws_subnet.protected_b.id,
    aws_subnet.protected_c.id
  ]
    tags = {
    Name = "${var.NAME}-db-subnet-group"
  }  
}


# resource "aws_secretsmanager_secret_version" "db_secretsmanager" {
#   secret_id     = aws_secretsmanager_secret.db.id
#   secret_string = jsonencode({
#     "username" = "changeme"
#     "password" = "changeme"
#     "engine" =  "mysql"
#     "host" = aws_rds_cluster.db.endpoint
#     "port" = aws_rds_cluster.db.port
#     "dbClusterIdentifier" = aws_rds_cluster.db.cluster_identifier
#     "dbname" = aws_rds_cluster.db.database_name
#   })
# }
