# importing the libraries
import logging

from flask import Flask, jsonify, request


app = Flask(__name__)

# logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)


@app.route('/api/events', methods=['POST'])
def post_streaming_data():
    data = request.json
    print(data)
    return jsonify({"status": "success", "data": data}), 201