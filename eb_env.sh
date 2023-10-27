#!/bin/bash

# Run `terraform apply` to ensure the outputs are up-to-date and capture the output
if terraform apply -auto-approve; then
    # Display the Terraform output from the captured file
    tee terraform_output.txt
    cat terraform_output.txt

    # Read variables from terraform.tfvars and provide default values if not found
    USERNAME=$(grep 'username' terraform.tfvars | awk -F '= ' '{print $2}' | tr -d '"')
    PASSWORD=$(grep 'password' terraform.tfvars | awk -F '= ' '{print $2}' | tr -d '"')
    DATABASE_NAME=$(grep 'DATABASE_NAME' terraform.tfvars | awk -F '= ' '{print $2}' | tr -d '"')
    S3_LOCATION=$(grep 's3_location' terraform.tfvars | awk -F '= ' '{print $2}' | tr -d '"')

    # Create a new .env file or overwrite an existing one
    cat <<EOF > .env
DB_HOST = "$(terraform output db_host)"
APP_URL = "$(terraform output app_url)"
load_balancer_dns = "$(terraform output load_balancer_dns)"
USERNAME=${USERNAME:-default_username}
PASSWORD=${PASSWORD:-default_password}
DATABASE_NAME=${DATABASE_NAME:-default_database}
S3_LOCATION=${S3_LOCATION:-default_s3_location}
EOF

    echo ".env file generated with Terraform output and variable values."
    # Optionally, you can print the contents of the .env file for verification
    cat .env
else
    echo "Terraform apply failed. Please check the Terraform output for errors."
fi
