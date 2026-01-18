# importing the libraries
from controller.etl import preprocess_events


def handler(event, context):
    preprocess_events(event)