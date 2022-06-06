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
      
    # Let's do a POST to an external API endpoint with data
    # defining the api-endpoint 
    API_ENDPOINT = "https://webhook-worker.scottvankalken.workers.dev/"
      
    # your API key here
    API_KEY = "XXXXXXXXXXXXXXXXX"
      
    # define headers and data portions
    headers = {"content-type":"application/json"}
    data = {'Category':json_event['category'],
            'Cloud Provider': json_event['cloud_provider'],
            'Account Name':json_event['account_name'],
            'Alert ID':json_event['state']['alert_id'],
            'Severity':json_event['state']['severity']}
      
    # sending post request and saving response as response object
    # inside lambda we need to encode the data object as json before sending
    r = requests.post(url = API_ENDPOINT, data = json.dumps(data), headers = headers)
      
    # extracting response text 
    api_response = r.text
    logger.info('Response from external API: %s', api_response)

    return {
        'statusCode' : '200',
        #'body': json.dumps(event)
        'body': json.dumps(json_event)
    }
