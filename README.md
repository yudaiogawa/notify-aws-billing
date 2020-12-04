# Notify AWS Billing

## Requirements

* awscli
* docker 19.03.0
* docker-compose
* node/npm
* python 3.8
* pip
* pipenv
* serverless framework
* slack webhook url

## Required Settings

#### AWS PROFILE

Requires the IAM user granted the `AdministratorAccess` or the IAM user granted the appropriate permission.

```sh
% aws configure --profile foobar
```

## Getting Started - Use Docker

1. Create `.env`
2. Create the docker image n container
3. Create a new Bash session in the container
4. Introduction
5. Invoke

1:

Define the following variables to `.env` .

* AWS_PROFILE
* WEBHOOK_URL

2:

```sh
% make up
```

3:

```sh
% make exec
```

4:

```sh
% npm i
% pipenv install -r requirements.txt
```

5:

```sh
% pipenv shell
% make invoke-local
```

## Getting Started - Use Host

1. Export the environment variables
2. Introduction
3. Invoke

1:

```sh
% export AWS_PROFILE=foobar
% export WEBHOOK_URL='https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX'
```

2:

```sh
% npm i
% pipenv install -r requirements.txt
```

3:

```sh
% pipenv shell
% make invoke-local
```

## Deploy

Deploys your entire service:

```sh
# Deploy to development.
% make deploy-dev

# Deploy to production.
% make deploy-prd
```

Deploys an function:

```sh
# Deploy to development.
% make deploy-func-dev

# Deploy to production.
% make deploy-func-prd
```

Invokes deployed function:

```sh
% make invoke
```

## License

This software is released under the MIT License, see LICENSE.
