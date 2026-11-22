
#!/bin/bash

URL="https://www.google.com"

HTTP_CODE=$(curl -L -s -o /dev/null \
-w "%{http_code}" --max-time 10 "$URL")

if [[ "$HTTP_CODE" == "200" ]]; then
    echo "Website is UP"
else
    echo "Website response issue: HTTP $HTTP_CODE"
fi
