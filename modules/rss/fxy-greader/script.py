import logging
import sys
from flask import Flask, jsonify, request
import os
# import json
import glob
import argparse
import feedparser
import time
import re
from waitress import serve

app = Flask(__name__)

logging.basicConfig(stream=sys.stdout, level=logging.INFO, format='%(asctime)s %(levelname)s %(message)s')


@app.before_request
def log_request_info():
    logging.info(f"Request: {request.method} {request.url} from {request.remote_addr}")
    logging.info(f"Headers: {dict(request.headers)}")
    logging.info(f"Body: {request.get_data()}")


@app.after_request
def log_response_info(response):
    logging.info(f"Response status: {response.status}")
    # logging.info(f"Response data: {response.get_data(as_text=True)}")
    return response


def load_latest_feed_result(feed_id, feeds_dir):
    results_dir = os.path.join(feeds_dir, feed_id, 'results')
    latest_file = max(glob.glob(os.path.join(results_dir, '*')), key=os.path.basename)
    with open(latest_file, 'r') as f:
        return latest_file, f.read()


def parse_feed_content(file_path, content):
    parsed_feed = feedparser.parse(content)
    return {
        'title': parsed_feed.feed.get('title', ''),
        'htmlUrl': parsed_feed.feed.get('link', ''),
        'firstitemmsec': int(os.path.basename(file_path))
    }


def map_entry_to_item(entry, feed_id, item_hash):
    return {
        "id": f"tag:google.com,2005:reader/item/{item_hash}",
        "origin": {
            "streamId": f"feed/{feed_id}",
            "title": entry.get('feed', {}).get('title', ''),
            "htmlUrl": entry.get('link', '')
        },
        "title": entry.get('title', ''),
        "author": entry.get('author', ''),
        "summary": {
            "content": entry.get('summary', '') or entry.get('content', [{'value': ''}])[0]['value']
        },
        "alternate": [{"href": entry.get('link', ''), "type": "text/html"}],
        "canonical": [{"href": entry.get('link', '')}],
        "published": time.mktime(entry.get('published_parsed')),
        "updated": time.mktime(entry.get('updated_parsed')),
        "unread": True,
        "categories": [
            "user/-/state/com.google/reading-list",
            "user/-/label/Uncategorized"
        ],
        "enclosure": [
            {"href": enclosure.get('href', ''), "type": enclosure.get('type', '')}
            for enclosure in entry.get('enclosures', [])
        ]
    }


@app.route('/accounts/ClientLogin', methods=['POST'])
def client_login():
    return "SID=a\nLSID=b\nAuth=c"


@app.route('/reader/api/0/user-info', methods=['GET'])
def get_user_info():
    return jsonify({
        'userId': "1",
        'userName': "fxyoge",
        'userProfileId': "1",
        'userEmail': "email@fxyoge.com",
        'isBloggerUser': False,
        'signupTimeSec': 1163850013,
        'isMultiLoginEnabled': False,
    })


@app.route('/reader/api/0/subscription/list', methods=['GET'])
def list_subscriptions():
    subscriptions = []
    feed_dir = os.path.join(app.config['DATA_DIR'], 'feeds')
    
    for feed_id in os.listdir(feed_dir):
        latest_file, latest_result = load_latest_feed_result(feed_id, feed_dir)
        parsed_data = parse_feed_content(latest_file, latest_result)
        
        subscriptions.append({
            'id': f"feed/{feed_id}",
            'title': parsed_data.get('title', ''),
            'categories': parsed_data.get('labels', []),
            'sortid': feed_id,
            'firstitemmsec': parsed_data['firstitemmsec'],
            'url': parsed_data.get('htmlUrl', ''),
            'htmlUrl': parsed_data.get('htmlUrl', ''),
            'iconUrl': ''  # Implement as needed.
        })
        
    return jsonify({'subscriptions': subscriptions})


@app.route('/reader/api/0/tag/list', methods=['GET'])
def list_tags():
    return jsonify({'tags': []})


@app.route('/reader/api/0/stream/items/ids', methods=['GET'])
def get_stream_items_ids():
    output = request.args.get('output', 'json')
    ot = int(request.args.get('ot', 0))

    if output != 'json':
        return jsonify({'error': 'Only JSON output is supported'}), 400

    items = []
    feed_dir = os.path.join(app.config['DATA_DIR'], 'feeds')

    for feed_id in os.listdir(feed_dir):
        results_dir = os.path.join(feed_dir, feed_id, 'results')
        
        latest_file = max(glob.glob(os.path.join(results_dir, '*')), key=os.path.basename)
        timestamp = int(os.path.basename(latest_file))
        
        if timestamp < ot:
            continue

        with open(latest_file, 'r') as f:
            content = f.read()
            parsed_feed = feedparser.parse(content)
            
            for entry in parsed_feed.entries:
                item_id = str(abs(hash(entry.get('id', '') or entry.get('link', ''))))
                timestamp_usec = str(int(time.time() * 1000000))
                
                items.append({
                    'id': item_id,
                    'directStreamIds': [],
                    'timestampUsec': timestamp_usec
                })

    items.sort(key=lambda x: x['timestampUsec'], reverse=True)

    return jsonify({
        'items': [],
        'itemRefs': items
    })


@app.route('/reader/api/0/stream/items/contents', methods=['POST'])
def get_stream_items_contents():
    if request.content_type != 'application/x-www-form-urlencoded':
        return jsonify({'error': 'Only application/x-www-form-urlencoded content type is supported'}), 400

    item_ids = request.form.getlist('i')
    if not item_ids:
        return jsonify({'error': 'No item IDs provided'}), 400

    requested_hashes = [re.search(r'item/([a-f0-9]+)$', item_id).group(1) for item_id in item_ids if re.search(r'item/([a-f0-9]+)$', item_id)]

    items = []
    feed_dir = os.path.join(app.config['DATA_DIR'], 'feeds')

    for feed_id in os.listdir(feed_dir):
        results_dir = os.path.join(feed_dir, feed_id, 'results')
        latest_file = max(glob.glob(os.path.join(results_dir, '*')), key=os.path.basename)
        
        with open(latest_file, 'r') as f:
            content = f.read()
            parsed_feed = feedparser.parse(content)
            
            for entry in parsed_feed.entries:
                item_hash = format(abs(hash(entry.get('id', '') or entry.get('link', ''))), 'x')
                
                if item_hash in requested_hashes:
                    item = map_entry_to_item(entry, feed_id, item_hash)
                    items.append(item)

    response = {
        "id": "user/-/state/com.google/reading-list",
        "updated": int(time.time()),
        "items": items,
    }

    return jsonify(response)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Inoreader-like API server for RSS feeds.')
    parser.add_argument('-d', '--data', type=str,
        help="Data directory for the downloaded feeds.",
        required=True)
    parser.add_argument('-p', '--port', type=int,
        help="Port for the server to run on.",
        default=35621)
    args = parser.parse_args()
    app.config['DATA_DIR'] = args.data

    serve(app, host="0.0.0.0", port=args.port)
