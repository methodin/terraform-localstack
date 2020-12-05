awslocal s3 cp /app/lambda.zip s3://deploy-local/app/lambda.zip

cd /app

# Remove existing .terraform in case it exists
rm -rf terraform/.terraform

# Run terraform init
cd terraform 
terraform init \
    -backend-config="endpoint=http://localstack:4566/terraform-local" \
    -backend-config="bucket=terraform-local" \
    -backend-config="profile=default" \
    dev

# Run terraform apply
terraform apply -auto-approve -var-file=local/vars_local.tfvars local
