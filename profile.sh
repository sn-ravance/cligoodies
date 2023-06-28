#!/bin/bash

csv_file="inactive.csv"

if [ ! -f "$csv_file" ]; then
  echo "CSV File $csv_file does not exist."
  echo 1
fi

while IFS=',' read -r _ value _; do
  echo "Processing value: $value"

  urlpf="https://api.atlassian.com/users/$value/manage/profile"
  curl --request GET --url $urlpf --header 'Authorization: Bearer ATCTT3xFfGN0psvWPL7VgEr6iYqSDah_Bbza6rDR6voiSGpKB8YryTQP9iaXzeDVY8yBI_gIZUZ1OcP-pPXsj4Ddkzk0XqKVY2h0OiXKsM93qc65lTu1zUwxCkEcpnZZvMes72o2yqI_Trhyz7QuuRcu7FeIsgEwJUN8-eDP2H1ndj6BcqCfoJQ=6684BFA4' --header 'Accept: application/json' | jq .

done < "$csv_file"
