
#!/bin/bash

# Application Log Monitoring

LOG_FILE="/var/log/syslog"
PATTERN="ERROR|CRITICAL|FATAL"

if [[ ! -r "$LOG_FILE" ]]; then
    echo "ERROR: Cannot read $LOG_FILE"
    exit 1
fi

echo "Scanning application/system logs..."

grep -Ei "$PATTERN" "$LOG_FILE" | tail -20

echo "Log monitoring completed."
