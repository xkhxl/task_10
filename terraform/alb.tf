# Application Load Balancer
resource "aws_lb" "strapi" {
  name               = "akhil-strapi-alb"
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = [var.alb_security_group_id]
}

# -------- BLUE TARGET GROUP --------
resource "aws_lb_target_group" "blue" {
  name        = "akhil-strapi-blue-tg"
  port        = 1337
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

# -------- GREEN TARGET GROUP --------
resource "aws_lb_target_group" "green" {
  name        = "akhil-strapi-green-tg"
  port        = 1337
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.strapi.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }

  lifecycle {
    ignore_changes = [
      default_action
    ]
  }
}

