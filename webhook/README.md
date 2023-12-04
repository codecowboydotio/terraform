# Provision API gateway and example lambda function as webhhook in AWS

This example provisions a lambda function and an API gateway into AWS in order to show how you would configure a webhook to work.

The webhook itself is a piece of python code that is deployed as a lambda function.
This piece of python code accepts a JSON payload of a certain format, then extracts some fields and sends it on to another endpoint via a POST request.

## What gets created

The terraform template will create the following resources:
- AWS API gateway
- Lambda function


## What to update
Look at the vars.tf file and change the resion - by default will deploy into the ap-southeast-2 region.


