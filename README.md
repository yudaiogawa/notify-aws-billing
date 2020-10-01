# Notify AWS Billing

## Requirements

- serverless framework
- python3.8
- pip
- pipenv
- docker
- awscli
- node/npm
- slack webhook url

## Config

```sh
% aws configure --profile foobar
```

## Debug

Activate pipenv shell.

```sh
% pipenv shell
```

Debug.

```sh
# On Terminal
% sls invoke local -f notify_aws_billing --aws-profile foobar

# Use Webhook-URL
% sls invoke local -f notify_aws_billing --aws-profile foobar
    --url='https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX'
```

## Deploy

```sh
% sls deploy --aws-profile foobar \
    --url="https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX"
```

## License

This software is released under the MIT License, see LICENSE.
