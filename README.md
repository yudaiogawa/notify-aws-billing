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

# sls config を使ってもいい
% sls config credentials --provider aws --key 1234 --secret 5678 --profile foobar
```

## Debug

venv起動

```sh
% pipenv shell
```

Debug

```sh
# Serverless Debug
% sls invoke local -f notify_aws_billing \
    --aws-profile foobar

# Use Webhook-URL
% sls invoke local -f notify_aws_billing \
    --url='https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX' \
    --aws-profile foobar
```

## Deploy

```sh
# Usually
% sls deploy \
    --url="https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX" \
    --aws-profile foobar

# specific stage
% sls deploy \
    --stage foo \
    --url="https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX" \
    --aws-profile foobar
```

## License

This software is released under the MIT License, see LICENSE.
