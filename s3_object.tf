resource "aws_s3_object" "env_file" {
  count  = var.upload_env_file ? 1 : 0
  bucket = var.s3_location
  key    = "web-app/.env"
  source = ".env"
}

resource "aws_s3_object" "tfvars_file" {
  count  = var.upload_tfvars_file ? 1 : 0
  bucket = var.s3_location
  key    = "web-app/terraform.tfvars"
  source = "terraform.tfvars"
}
