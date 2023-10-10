resource "aws_lb" "alb" {
  name            = "${var.NAME}-alb"
  subnets         = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id,
    aws_subnet.public_c.id
  ]
  internal = false
  security_groups = [aws_security_group.alb.id]

  tags = {
    Name = "${var.NAME}-alb"
  }  
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.id
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "403 page error"
      status_code  = "403"
    }
  }

  tags = {
    Name = "${var.NAME}-alb-listener"
  }  
}