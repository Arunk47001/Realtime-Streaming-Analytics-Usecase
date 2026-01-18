# importing the libraries
import boto3
import time
import random
import json
import os


def stream_event():
    try:
        print("streaming the Incoming Data")
        kinesis = boto3.client('kinesis', region_name =os.environ['REGION'])
        click_event = {
        "user_id": random.randint(1, 100),
        "page": random.choice(["home", "product", "cart", "checkout"]),
        "timestamp": int(time.time())
    }

        print(f"Sending event: {click_event}")

        kinesis.put_record(
        StreamName=os.environ['KINESIS_DS'],
        Data=json.dumps(click_event),
        PartitionKey=str(click_event["user_id"])
    )
    except Exception as e:
        print(e)
        raise ValueError("Issue in Sending the Events")