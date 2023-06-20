import requests
import json

url = "https://api.atlassian.com/users/{account_id}/manage/lifecycle/disable"
headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer <access_token>"
}

payload = {
    "message": "On 6-month suspension"
}

# Read the file with a list of account_id values
with open('account_ids.txt', 'r') as file:
    account_ids = file.read().splitlines()

for account_id in account_ids:
    # Replace the placeholder in the URL with the current account_id
    request_url = url.replace('{account_id}', account_id)
    
    # Convert the payload to JSON string
    payload_json = json.dumps(payload)
    
    response = requests.post(request_url, data=payload_json, headers=headers)
    
    print(response.text)
