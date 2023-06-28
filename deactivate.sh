#!/bin/bash

csv_file="inactive.csv"
bearer_token="ATCTT3xFfGN0psvWPL7VgEr6iYqSDah_Bbza6rDR6voiSGpKB8YryTQP9iaXzeDVY8yBI_gIZUZ1OcP-pPXsj4Ddkzk0XqKVY2h0OiXKsM93qc65lTu1zUwxCkEcpnZZvMes72o2yqI_Trhyz7QuuRcu7FeIsgEwJUN8-eDP2H1ndj6BcqCfoJQ=6684BFA4"

if [ ! -f "$csv_file" ]; then
  echo "CSV File $csv_file does not exist."
  exit 1
fi

tail -n +2 "$csv_file" | while IFS=',' read -r email value _; do
  #echo "Processing account with email: $email and value: $value"

  urlpf="https://api.atlassian.com/users/$value/manage/profile"
  response=$(curl --fail --request GET --url "$urlpf" \
             --header "Authorization: Bearer $bearer_token" \
             --header 'Accept: application/json' 2>/dev/null)

  if [ $? -eq 0 ]; then
    account_status=$(echo "$response" | jq -r '.account_status')
    if [ "$account_status" = "active" ]; then
      echo "The account with email '$email' and value '$value' is active."
      read -p "Do you want to disable the account? (y/n): " confirm

      if [ "$confirm" = "y" ]; then
        echo "Deactivating account for email: $email and value: $value"

        urlrm="https://api.atlassian.com/users/$value/manage/lifecycle/disable"
        disable_response=$(curl --request GET --url "$urlrm" \
                          --header "Authorization: Bearer $bearer_token" \
                          --header 'Content-Type: application/json' \
                          --data '{"message": "No longer with the company"}' 2>/dev/null)
        if [ $? -eq 0 ]; then
          echo "Account deactivated successfully."
        else
          echo "Failed to deactivate account."
        fi
      else
        echo "Skipping account deactivation for email: $email and value: $value"
      fi
    else
      echo "Account status is not active for email: $email"
    fi
  else
    echo "Request failed for email: $email and value: $value"
  fi
done
