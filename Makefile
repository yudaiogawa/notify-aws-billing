up: ## docker-compose up -d
	docker-compose up -d
exec: ## docker exec -it mylambda /bin/bash
	docker exec -it mylambda /bin/bash
stop: ## docker-compose stop
	docker-compose stop
start: ## docker-compose start
	docker-compose start
down: ## docker-compose down -v --rmi all
	docker-compose down -v --rmi all

invoke-local: ## Invokes a function locally.
	sls invoke local -f notify_aws_billing --aws-profile $(AWS_PROFILE)
invoke-local-notify: ## Invokes a function locally and notify Slack.
	sls invoke local -f notify_aws_billing --aws-profile $(AWS_PROFILE) --url=$(WEBHOOK_URL)
invoke-dev: ## Invokes deployed function in development.
	sls invoke -f notify_aws_billing --logs
invoke-prd: ## Invokes deployed function in production.
	sls invoke -f notify_aws_billing --logs --stage prd

deploy-dev: ## Deploys your entire service via CloudFormation to development.
	sls deploy --aws-profile $(AWS_PROFILE) --url=$(WEBHOOK_URL)
deploy-prd: ## Deploys your entire service via CloudFormation to production.
	sls deploy --aws-profile $(AWS_PROFILE) --url=$(WEBHOOK_URL) --stage=prd

deploy-func-dev: ## deploys an function to development.
	sls deploy function -f notify_aws_billing --aws-profile $(AWS_PROFILE) --url=$(WEBHOOK_URL)
deploy-func-prd: ## deploys an function to production.
	sls deploy function -f notify_aws_billing --aws-profile $(AWS_PROFILE) --url=$(WEBHOOK_URL) --stage=prd

rm-dev: ## Remove the deployed service from the provider in development.
	sls remove -v
rm-prd: ## Remove the deployed service from the provider in production.
	sls remove -v --stage prd

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
