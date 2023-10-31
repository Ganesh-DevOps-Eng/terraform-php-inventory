# Load Balancer
resource "aws_lb" "eb_lb" {
  name               = "${var.project_name}-load-balancer"
  load_balancer_type = "application"
  subnets            = module.VPC-Module.public_subnet[*]
  security_groups    = [module.VPC-Module.alb_sg]

  tags = {
    Name = "${var.project_name}-eb_lb"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.eb_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.eb_lb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_iam_server_certificate.self_signed_cert.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
    }
  }
}


resource "aws_lb_target_group" "eb_tg" {
  name     = "${var.project_name}-eb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.VPC-Module.vpc
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.eb_tg.arn
  target_id        = "i-0e1035204f8d26aec"
  port             = 80
}