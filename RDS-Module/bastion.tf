resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = module.VPC-Module.public_subnet[0]
  vpc_security_group_ids = [module.VPC-Module.bastion_sg]
  key_name               = aws_key_pair.bastion_pair.key_name

  connection {
    type        = "ssh"
    user        = "ec2-user"  # The SSH username
    private_key = file("matelliocorp_bastion_key.pem")
    host        = self.public_ip  # The host to connect to
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update",
      "sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm",
      "sudo dnf install mysql80-community-release-el9-1.noarch.rpm -y",
      "sudo dnf install mysql-community-client -y",
      "MYSQL_HOST=$(echo ${aws_db_instance.rds.endpoint} | cut -d':' -f1)",
      "MYSQL_USER=\"${var.username}\"",
      "MYSQL_PASSWORD=\"${var.password}\"",
      "DATABASE_NAME=\"${var.DATABASE_NAME}\"",
      "mysql -h \"$MYSQL_HOST\" -u \"$MYSQL_USER\" -p\"$MYSQL_PASSWORD\" -e \"CREATE DATABASE $DATABASE_NAME;\"",
      "sudo yum install git -y",
      "git clone https://github.com/${var.FullRepositoryId}",
      "cd php-inventory/",
      "mysql -h \"$MYSQL_HOST\" -u \"$MYSQL_USER\" -p\"$MYSQL_PASSWORD\" \"$DATABASE_NAME\" < database/store.sql",
      "# Update sso-login.php file",
      "sed -i \"s|'entityId' => 'https://.*\\.elasticbeanstalk\\.com/|'entityId' => 'https:${aws_elastic_beanstalk_environment.eb_env.endpoint_url}/|\" sso-login.php",
      "sed -i \"s|'url' => 'https://.*\\.elasticbeanstalk\\.com/|'url' => 'https:${aws_elastic_beanstalk_environment.eb_env.endpoint_url}/dashboard.php|\" sso-login.php",
      "# Update the .env file on git",
      "cd php_action/",
      "sed -i \"s/DB_HOST=.*/DB_HOST=$MYSQL_HOST/\" .env",
      "sed -i \"s/DB_USERNAME=.*/DB_USERNAME=$MYSQL_USER/\" .env",
      "sed -i \"s/DB_PASSWORD=.*/DB_PASSWORD=$MYSQL_PASSWORD/\" .env",
      "sed -i \"s/DB_NAME=.*/DB_NAME=$DATABASE_NAME/\" .env",
      "sed -i \"s|STORE_URL=http://.*|STORE_URL=http://${aws_elastic_beanstalk_environment.eb_env.endpoint_url}/|\" .env",
      "git add .env",
      "git commit -m 'Update .env file'",
      "git remote set-url origin https://github.com/${var.FullRepositoryId}.git",
      "git remote remove origin",
      "git config --global user.email 'ganeshjatms@gmail.com'",
      "git config --global user.name 'Ganesh-DevOps-Eng'",
      "git remote add origin https://Ganesh-DevOps-Eng:${var.git_pat}@github.com/${var.FullRepositoryId}.git",
      "git push -u origin main",
      "# Perform your deployment to Elastic Beanstalk here"
    ]
  }
}
