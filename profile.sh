#!/bin/bash

csv_file="inactive.csv"

if [ ! -f "$csv_file" ]; then
  echo "CSV File $csv_file does not exist."
  echo 1
fi

while IFS=',' read -r _ value _; do
  echo "Processing value: $value"

  urlpf="https://api.atlassian.com/users/$value/manage/profile"
  curl --request GET --url $urlpf --header 'Authorization: Bearer KEY' --header 'Accept: application/json' | jq .

done < "$csv_file"
