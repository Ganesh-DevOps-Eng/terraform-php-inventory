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

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.eb_lb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_iam_server_certificate.self_signed_cert.arn
  ssl_policy      = "ELBSecurityPolicy-2016-08"
  default_action {
        type = "fixed-response"

        fixed_response {
            content_type = "text/plain"
            status_code  = "200"
        }
    }
}
