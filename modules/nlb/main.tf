resource "aws_lb" "nlb" {
  name               = "nlb"
  internal           = false
  load_balancer_type = "network"
  subnets = [var.public_subnet_a_id,var.public_subnet_b_id]
}

resource "aws_lb_target_group" "nlb_tg" {
  name        = "nlb-tg"
  port        = 80
  protocol    = "TCP"
  vpc_id = var.vpc_id


  target_type = "instance"
}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg.arn
  }
}