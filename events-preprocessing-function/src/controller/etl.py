# importing the libraries
import json
import base64

from infra.timestreamdb import write_tb

def preprocess_events(event):
    print("incoming event:", event)
    records =[]
    for record in event['Records']:
        payload = json.loads(base64.b64decode(record['kinesis']['data']))
        print("decoded data:", payload)
        try:
            user_id = str(payload['user_id'])
            page =payload['page']
            timestamp = str(int(payload['timestamp']) * 1_000_000_000)
            record = {
            'Dimensions': [
                {'Name': 'user_id', 'Value': user_id},
                {'Name': 'page', 'Value': page}
            ],
            'MeasureName': 'page_view',
            'MeasureValue': '1',
            'MeasureValueType': 'BIGINT',
            'Time': timestamp,
            'TimeUnit' : 'NANOSECONDS'
            }
            records.append(record)
        except Exception as e:
            print(e)
            raise ValueError("Failed Process the records")

    if records:
        write_tb(records)
