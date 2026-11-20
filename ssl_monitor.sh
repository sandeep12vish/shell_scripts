
#!/bin/bash

# SSL Certificate Expiry Monitoring

DOMAIN="example.com"
WARNING_DAYS=30

EXPIRY_DATE=$(echo | openssl s_client \
    -servername "$DOMAIN" \
    -connect "$DOMAIN:443" 2>/dev/null |
    openssl x509 -noout -enddate |
    cut -d= -f2)

if [[ -z "$EXPIRY_DATE" ]]; then
    echo "ERROR: Unable to retrieve SSL certificate"
    exit 1
fi

EXPIRY_EPOCH=$(date -d "$EXPIRY_DATE" +%s)
CURRENT_EPOCH=$(date +%s)

DAYS_LEFT=$(( (EXPIRY_EPOCH - CURRENT_EPOCH) / 86400 ))

echo "$DOMAIN certificate expires in $DAYS_LEFT days"

if (( DAYS_LEFT <= WARNING_DAYS )); then
    echo "WARNING: SSL certificate renewal required"
fi
