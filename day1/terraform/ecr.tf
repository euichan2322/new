resource "aws_ecr_repository" "stress_ecr" {
  name = "${var.NAME}-stress"
  force_delete = true
}


resource "aws_ecr_repository" "product_ecr" {
  name = "${var.NAME}-product"
  force_delete = true
}
