import json
#from botocore.vendored import requests
import urllib3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    raw_event = event['body']
    uri_path = event['path'].strip("/")
    logger.info(event)
    json_event = json.loads(raw_event)
    logger.info(json_event)


    # At this point I can take the path variable uri_path and write the alert to a bucket that is for a
    # specific customer or whatever the case may be.


    # In the event that you want to POST the data to either an authenticated or unauthenticated API
    # You would invoke something like below

    # Let's do a POST to an external API endpoint with data
    # defining the api-endpoint
    API_ENDPOINT = "https://httpbin.org/post"

    # your API key here
    #API_KEY = "XXXXXXXXXXXXXXXXX"

    # sending post request and saving response as response object
    # inside lambda we need to encode the data object as json before sending
    http = urllib3.PoolManager()

    data = json.dumps(json_event).encode('utf8')

    headers = {
      'Content-Type': 'application/json'
    }
    response = http.request(
      'POST',
      API_ENDPOINT,
      body = data,
      headers = headers
    )

    # extracting response text
    logger.info('data : %s', data)
    logger.info('Response from external API resp : %s', response)
    logger.info('Response from external API resp : %s', response.status)

    return {
        'statusCode' : '200',
        'body': response.data.decode("utf-8")
    }

