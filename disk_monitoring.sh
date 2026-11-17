
#!/bin/bash

# Disk Monitoring Script

WARNING=80
CRITICAL=90

df -P -x tmpfs -x devtmpfs | awk 'NR>1 {
    gsub("%","",$5)

    if ($5 >= 90)
        status="CRITICAL"
    else if ($5 >= 80)
        status="WARNING"
    else
        status="OK"

    printf "%-20s %3s%% %s\n", $6, $5, status
}'
