# importing the libraries
import os
import boto3


def write_tb(records):
    try:
        timestream = boto3.client('timestream-write', region_name= os.environ['REGION'])
        timestream.write_records(
            DatabaseName=os.environ['DATABASE_NAME'],
            TableName=os.environ['TABLE_NAME'],
            Records=records
        )
        print(f"Inserted {len(records)} records")
    except Exception as e:
        print(f"Failed to write to Timestream: {e}")
        raise ValueError("Failed to Write TimestreamDB")