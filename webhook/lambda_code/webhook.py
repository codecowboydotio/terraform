import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    raw_event = event['body']
    logger.info(event['body'])
    json_event = json.loads(raw_event)
    logger.info(type(json_event))
    logger.info('Category: %s', json_event['category'])
    logger.info('Cloud Provider: %s', json_event['cloud_provider'])
    logger.info('Account Name: %s', json_event['account_name'])
    logger.info('Alert ID: %s', json_event['state']['alert_id'])
    logger.info('Severity: %s', json_event['state']['severity'])
    return {
        'statusCode' : '200',
        #'body': json.dumps(event)
        'body': json.dumps(json_event)
    }
