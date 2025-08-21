resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_security_group_ids
  subnets            = var.public_subnet_ids
  enable_deletion_protection = false

  tags = { Name = var.alb_name }
}

resource "aws_lb_target_group" "frontend_tg" {
  name     = var.frontend_target_group_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "frontend_instances_attachment" {
  count            = length(var.frontend_instances_ids)
  target_group_arn = aws_lb_target_group.frontend_tg.arn
  target_id        = var.frontend_instances_ids[count.index]
  port             = 80
}
