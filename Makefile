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

invoke: ## Invokes deployed function.
	sls invoke -f notify_aws_billing --logs
invoke-local: ## Invokes a function locally.
	sls invoke local -f notify_aws_billing --aws-profile $(AWS_PROFILE)
invoke-local-notify: ## Invokes a function locally and notify Slack.
	sls invoke local -f notify_aws_billing --aws-profile $(AWS_PROFILE) --url=$(WEBHOOK_URL)

deploy-dev: ## Deploys your entire service via CloudFormation to development.
	sls deploy --aws-profile $(AWS_PROFILE) --url=$(WEBHOOK_URL)
deploy-prd: ## Deploys your entire service via CloudFormation to production.
	sls deploy --aws-profile $(AWS_PROFILE) --url=$(WEBHOOK_URL) --stage=prd

deploy-func-dev: ## deploys an function to development.
	sls deploy function -f notify_aws_billing --aws-profile $(AWS_PROFILE) --url=$(WEBHOOK_URL)
deploy-func-prd: ## deploys an function to production.
	sls deploy function -f notify_aws_billing --aws-profile $(AWS_PROFILE) --url=$(WEBHOOK_URL) --stage=prd

remove: ## Remove the deployed service from the provider.
	sls remove -v

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
