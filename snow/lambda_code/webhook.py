import json
#from botocore.vendored import requests
import urllib3
import logging
import requests

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
    #API_ENDPOINT = "https://httpbin.org/post"
    API_ENDPOINT = "https://dev242599.service-now.com/api/now/table/incident"

    # your API key here
    #API_KEY = "XXXXXXXXXXXXXXXXX"

    # sending post request and saving response as response object
    # inside lambda we need to encode the data object as json before sending
    data = json.dumps(json_event).encode('utf8')
    description = json_event['alert']['name']
    policy = json_event['alert']['body']
    event_url = json_event['event']['url']
    long_desc = str(policy + "\n\n" + event_url)
    user = "admin"
    pwd = "4RhS3=nTfFb^"

    headers = {
      'Content-Type':'application/json',
      'Accept':'application/json'
    }
    response = requests.post(
      API_ENDPOINT,
      json = {"short_description": description, "description": long_desc, "urgency":"2"},
      auth = (user, pwd),
      headers = headers
    )

    # extracting response text
    logger.info('data : %s', data)
    logger.info('Response from external API resp : %s', response.text)
    logger.info('Response from external API resp : %s', response.status_code)

    return {
        'statusCode' : '200',
        'body': response.text
    }

