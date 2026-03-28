#!/bin/bash
DIR="/Users/aaronmandelbaum/Desktop/stuff/marino project/marino-gym"

curl -s \
  -H "Accept: application/json, text/javascript, */*; q=0.01" \
  -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36" \
  -H "Referer: https://recreation.northeastern.edu/" \
  -H "Origin: https://recreation.northeastern.edu" \
  -H "X-Requested-With: XMLHttpRequest" \
  "https://goboardapi.azurewebsites.net/api/FacilityCount/GetCountsByAccountAPIKey?AccountAPIKey=2a2be0d8-df10-4a48-bedd-b3bc0cd628e7" \
  -o "$DIR/data.json"

if python3 -c "import json; data=json.load(open('$DIR/data.json')); assert isinstance(data, list)" 2>/dev/null; then
  cd "$DIR"
  git add data.json
  git diff --cached --quiet || (git commit -m "Update occupancy data" && git push)
  echo "$(date): Success"
else
  echo "$(date): Failed to fetch valid data"
fi
