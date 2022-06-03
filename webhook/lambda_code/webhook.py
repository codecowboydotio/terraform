import json
import requests
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
    # curl -X POST https://webhook-worker.scottvankalken.workers.dev/ -H "Content-Type: application/json" -d '{"foo":"bar"}'
    ####
      
    # defining the api-endpoint 
    API_ENDPOINT = "https://webhook-worker.scottvankalken.workers.dev/"
      
    # your API key here
    API_KEY = "XXXXXXXXXXXXXXXXX"
      
    headers = {"content-type":"application/json"}
    data = {"Category":"paste"}
      
    # sending post request and saving response as response object
    r = requests.post(url = API_ENDPOINT, data = json.dumps(data), headers = headers)
      
    # extracting response text 
    api_response = r.text
    logger.info('Response from external API: %s', api_response)
    ####

    return {
        'statusCode' : '200',
        #'body': json.dumps(event)
        'body': json.dumps(json_event)
    }
