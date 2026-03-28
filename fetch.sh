#!/bin/bash
# Run this once to set up: chmod +x fetch.sh
# Then add to cron: */5 * * * * /Users/aaronmandelbaum/Desktop/stuff/marino\ project/marino-gym/fetch.sh

DIR="/Users/aaronmandelbaum/Desktop/stuff/marino project/marino-gym"

curl -s \
  -H "Accept: application/json, text/javascript, */*; q=0.01" \
  -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36" \
  -H "Referer: https://www.connect2mycloud.com/" \
  -H "Origin: https://www.connect2mycloud.com" \
  -H "X-Requested-With: XMLHttpRequest" \
  -c "$DIR/.cookies" \
  "https://goboardapi.azurewebsites.net/api/FacilityCount/GetCountsByAccountAPIKey?AccountAPIKey=1a0b4030-78cb-4f32-90e5-3a041ac6b640" \
  -o "$DIR/data.json"

# Check if we got valid JSON
if python3 -c "import json,sys; data=json.load(open('$DIR/data.json')); assert isinstance(data, list)" 2>/dev/null; then
  cd "$DIR"
  git add data.json
  git diff --cached --quiet || git commit -m "Update occupancy data" && git push
  echo "$(date): Data updated successfully"
else
  echo "$(date): Failed to fetch valid data"
fi
