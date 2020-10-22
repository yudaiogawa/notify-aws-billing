import datetime
import json
import os
import pprint

import boto3
import requests

from logging import basicConfig, getLogger, StreamHandler, DEBUG, Formatter

basicConfig(level=DEBUG)
logger = getLogger('notify_aws_billing')
handler = StreamHandler()
handler.setLevel(DEBUG)
handler.setFormatter(Formatter('%(asctime)s %(levelname)s %(name)s: %(message)s'))
logger.setLevel(DEBUG)
logger.addHandler(handler)
logger.propagate = False


def notify_aws_billing(event, context) -> None:
    client = boto3.client('ce')
    (start_date, end_date) = get_date_range()

    cost = get_cost(client, start_date, end_date)
    logger.debug("unblended_cost: %5.2f" % cost)

    if cost == 0:
        msg = get_msg_only_cost(cost, start_date, end_date)
    else:
        msg = get_msg(cost, get_services_billing(client, start_date, end_date), start_date, end_date)

    webhook_url = os.getenv('WEBHOOK_URL')
    if webhook_url != 'undefined':
        post_slack(webhook_url, msg)
    else:
        pprint.pprint(msg, width=120)


def get_msg_only_cost(total_cost, start_date, end_date) -> dict:
    summary = "AWS COST $%5.2f on %s." % (total_cost, start_date)
    attachments = {'color': 'warning'}
    msg = {
        'icon_emoji': ':amazon_web_services:',
        'username': 'AWS COST BOT',
        'text': summary,
        'attachments': [attachments]
    }
    return msg


# TODO
def get_msg_detail() -> str:
    logger.debug("get_msg_detail")


def get_cost(client, start_date, end_date) -> float:
    request_params = {
        'TimePeriod': {
            'Start': start_date.isoformat(),
            'End': end_date.isoformat(),
        },
        'Granularity': 'MONTHLY',
        'Metrics': ['UnblendedCost'],
    }

    resp = client.get_cost_and_usage(**request_params)
    return float(resp['ResultsByTime'][0]['Total']['UnblendedCost']['Amount'])


def get_services_billing(client, start_date, end_date) -> dict:
    request_params = {
        'TimePeriod': {
            'Start': start_date.isoformat(),
            'End': end_date.isoformat(),
        },
        'Granularity': 'MONTHLY',
        'Metrics': ['UnblendedCost'],
        'GroupBy': [
            {
                'Type': 'DIMENSION',
                'Key': 'SERVICE'
            }
        ]
    }

    resp = client.get_cost_and_usage(**request_params)
    return resp['ResultsByTime'][0]['Groups']


def get_msg(total_cost, groups, start_date, end_date) -> dict:
    end_date = end_date - datetime.timedelta(days=1)
    date_range = "FROM %s TO %s." % (start_date.isoformat(), end_date.isoformat())

    summary = "AWS COST $%5.2f.\n%s" % (total_cost, date_range)
    detail = '```'
    for group in groups:
        detail += "%s: $%5.2f\n" % (group['Keys'][0],
                                    float(group['Metrics']['UnblendedCost']['Amount']))
    detail += '```'

    attachments = {
        'color': 'warning',
        'fields': [
            {
                'title': 'DETAIL',
                'value': detail
            }
        ]
    }
    msg = {
        'icon_emoji': ':amazon_web_services:',
        'username': 'AWS COST BOT',
        'text': summary,
        'attachments': [attachments]
    }
    return msg


def post_slack(webhook_url, msg) -> None:
    resp = requests.post(webhook_url, json.dumps(msg))
    if resp.status_code != 200:
        logger.error("HTTP %s: %s" % (resp.status_code, resp.text))


def get_date_range() -> (datetime, datetime):
    today = datetime.date.today()
    firstday_of_month = datetime.date.today().replace(day=1)

    if today == firstday_of_month:
        lastday_of_lastmonth = firstday_of_month + datetime.timedelta(days=-1)
        firstday_of_lastmonth = lastday_of_lastmonth.replace(day=1)
        return firstday_of_lastmonth, today

    return firstday_of_month, today
