resource "tls_self_signed_cert" "self_signed_cert" {
  private_key_pem = tls_private_key.my_private_key.private_key_pem

  subject {
    common_name  = var.root_domain_name
    organization = "Matellio India Pvt Ltd"
  }

  validity_period_hours = 8760  

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}
resource "aws_iam_server_certificate" "self_signed_cert" {
  name              = "my-self-signed-cert"
  private_key       = tls_private_key.my_private_key.private_key_pem
  certificate_body  = tls_self_signed_cert.self_signed_cert.cert_pem
}


resource "aws_route53_zone" "main" {
  name = var.root_domain_name
}

resource "aws_route53_record" "lb_record" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.${var.root_domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.eb_lb.dns_name
    zone_id                = aws_lb.eb_lb.zone_id
    evaluate_target_health = true
  }
}
