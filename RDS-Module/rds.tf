module "VPC-Module" {
  source                    = "../VPC-Module"
  vpc_cidr_block            = var.vpc_cidr_block
  project_name              = var.project_name
  az_count                  = var.az_count
}


resource "aws_db_subnet_group" "db_sg" {
  name        = "cse-cr"
  description = "Private subnets for RDS instance"
  subnet_ids  = module.VPC-Module.public_subnet
  tags = {
    Name = "db_sg"
  }
}

# RDS Instance


resource "aws_db_instance" "rds" {
  identifier             = "${var.project_name}-rds"
  engine                 = "mysql"
  engine_version         = "8.0" # Choose a supported version
  instance_class         = "db.t4g.large"
  allocated_storage      = 20
  storage_type           = "gp3"
  username               = var.username
  password               = var.password
  db_subnet_group_name   = aws_db_subnet_group.db_sg.name
  vpc_security_group_ids = module.VPC-Module.rds_sg
  skip_final_snapshot    = true

  tags = {
    Name = "vprofile_rds"
  }
}

