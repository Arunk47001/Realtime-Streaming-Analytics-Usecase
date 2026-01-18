# importing the libraries
import awsgi
import json

from controller.app import app
from controller.stub import stream_event


def handler(event, context):
    if "httpMethod" in event:
        return awsgi.response(app, event, context)

    if "TYPE" in event:
        stream_event()
        return {
            "statusCode": 200,
            "body": json.dumps("Event sent to Kinesis")
        }
