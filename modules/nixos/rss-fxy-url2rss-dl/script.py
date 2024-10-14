import argparse
import json
import os
import requests
import time
import platformdirs
import feedparser


def fetch_feed(url: str) -> requests.Response:
    response = requests.get(url)
    response.raise_for_status()
    return response


def map_entry_to_item(entry):
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


def main(config_file: str, output_dir: str):
    if not os.path.isfile(config_file):
        print(f"Configuration file '{config_file}' does not exist.")
        return
    
    try:
        with open(config_file, 'r') as file:
            config = json.load(file)
    except json.JSONDecodeError as e:
        print(f"Error parsing the configuration file '{config_file}': {e}")
        return
    except Exception as e:
        print(f"Unexpected error reading the configuration file '{config_file}': {e}")
        return
    
    for entry in config.get('urls', []):
        feed_id = entry.get('id')
        url = entry.get('url')
        frequency = entry.get('frequency')
        labels = entry.get('labels', [])
        
        if not feed_id or not url or not isinstance(frequency, int):
            print(f"Invalid entry in configuration: {entry}")
            continue
        
        feed_dir = os.path.join(output_dir, "feeds", feed_id)
        entries_dir = os.path.join(feed_dir, "entries")
        
        if not os.path.exists(feed_dir):
            os.makedirs(feed_dir)
        
        if not os.path.exists(entries_dir):
            os.makedirs(entries_dir)
        
        timestamps = [int(ts) for ts in os.listdir(entries_dir) if ts.isdigit()]
        latest_timestamp = max(timestamps, default=0)
        current_time = int(time.time() * 1000)
        
        if current_time - latest_timestamp < (frequency * 1000):
            print(f"Feed from {url} is up-to-date. Skipping download.")
            continue
        
        try:
            response = fetch_feed(url)
        except requests.RequestException as e:
            print(f"Error fetching the feed from {url}: {e}")
            continue
        
        timestamp = int(time.time() * 1000)
        file_path = os.path.join(entries_dir, str(timestamp))
        
        try:
            with open(file_path, 'wb') as file:
                file.write(response.content)
            print(f"Feed from {url} downloaded and saved to {file_path}")
        except IOError as e:
            print(f"Error saving the feed to {file_path}: {e}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Download feeds based on configuration.")
    parser.add_argument('-c', '--config', type=str,
        help="Path to the JSON configuration file.",
        default=f"{platformdirs.user_config_dir('fxy-url2rss-dl')}/config.json")
    parser.add_argument('-o', '--output', type=str,
        help="Directory to save the downloaded feeds.",
        required=True)
    args = parser.parse_args()

    main(args.config, args.output)
