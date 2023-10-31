provider "aws" {
  region = var.region
}
terraform {
  backend "s3" {
    bucket         = "elasticbeanstalk-us-east-1-015058543222"
    key            = "terraform.tfstate"
    region         = "us-east-1"  # Use the appropriate AWS region
  }
}
resource "aws_s3_object" "env_file" {
  bucket = var.s3_location
  key    = "web-app/.env"
  source = ".env"
  etag = "force-update"
}

module "RDS-Module" {
  source            = "./RDS-Module"
  vpc_cidr_block    = var.vpc_cidr_block
  project_name      = var.project_name
  az_count          = var.az_count
  username          = var.username
  password          = var.password
  instance_type     = var.instance_type
  eb_solution_stack = var.eb_solution_stack
  ami_id            = var.ami_id
  root_domain_name  = var.root_domain_name
  DATABASE_NAME     = var.DATABASE_NAME
  FullRepositoryId  = var.FullRepositoryId
  git_pat = var.git_pat
}

module "CICD-Module" {
  source           = "./CICD-Module"
  project_name     = var.project_name
  region           = var.region
  s3_location      = var.s3_location
  ConnectionArn    = var.ConnectionArn
  FullRepositoryId = var.FullRepositoryId
  BranchName       = var.BranchName
}