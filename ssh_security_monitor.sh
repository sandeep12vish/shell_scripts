
#!/bin/bash

# SSH Failed Login Monitoring

echo "===== SSH SECURITY REPORT ====="

if command -v journalctl >/dev/null 2>&1; then

    journalctl -u ssh -u sshd --since "1 hour ago" \
        --no-pager 2>/dev/null |
        grep -Ei "failed password|authentication failure" |
        tail -20

elif [[ -r /var/log/auth.log ]]; then

    grep -Ei "failed password|authentication failure" \
        /var/log/auth.log | tail -20

elif [[ -r /var/log/secure ]]; then

    grep -Ei "failed password|authentication failure" \
        /var/log/secure | tail -20

else
    echo "No readable authentication log found."
    exit 1
fi
