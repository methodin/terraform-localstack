# HELP
# This will output the help for each task
.PHONY: help
help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

null:
	help

# Makefile Command Line Arguments!
EVENT =
ARGS = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`

# Terraform container
TERRAFORM := docker run -i -t \
		--network=my_networ \
		--add-host terraform-local.localstack:`docker inspect -f '{{ .NetworkSettings.Networks.my_network.IPAddress }}' localstack` \
		-v `pwd`/terraform:/app/ \
		-v ~/.aws:/root/.aws \
		-e TF_LOG=ERROR \
		--user $(id -u):$(id -g) \
		-w /app hashicorp/terraform:0.12.26

.PHONY: aws
aws: ## Execute AWS cli commands against a localstack runway
	@aws --endpoint-url=http://0.0.0.0:4566 $(ARGS)

.PHONY: init
init: ## Terraform init
	@$(TERRAFORM) init \
		-backend-config="endpoint=http://localstack:4566/deploy-local" \
		-backend-config="bucket=deploy-local" \
		-backend-config="profile=default" \
		local

.PHONY: plan
plan: ## Terraform plan
	@$(TERRAFORM) plan -no-color -var-file=local/vars_local.tfvars local

.PHONY: apply
apply: ## Terraform apply
	@$(TERRAFORM) apply -var-file=local/vars_local.tfvars local

.PHONY: destroy
destroy: ## Terraform destroy
	@$(TERRAFORM) destroy -var-file=local/vars_local.tfvars local
