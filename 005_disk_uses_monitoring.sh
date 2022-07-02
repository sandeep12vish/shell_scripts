#!/bin/bash


MAILID="sandeep12vish@gmail.com"

ALUE=80

SERVERNAME=$(hostname)

MAIL=/bin/mail

for line in $(df -hP | egrep '^/dev/' | awk '{ print $1 "_:_" $5 }')
  do
    FILESYSTEM=$(echo "$line" | awk -F"_:_" '{ print $1 }')
    DISK_USAGE=$(echo "$line" | awk -F"_:_" '{ print $2 }' | cut -d'%' -f1 )

    if [ $DISK_USAGE -ge $VALUE ];
    then
      EMAIL="$SERVERNAME - $(date): $FILESYSTEM Exceeded the threshold VALUE\n"
      EMAIL="$EMAIL\n Usage Details\n Current Usage:($DISK_USAGE%) Threshold value: ($VALUE%)"
      echo -e "$EMAIL" | $MAIL -s ""$SERVERNAME" Disk Usage Alert: Needs Attention!" "$MAILID"
    elif [ $DISK_USAGE -lt $VALUE ];
    then
      EMAIL="$EMAIL\n$FILESYSTEM ($DISK_USAGE%) is lessthan the threshold ($VALUE%)"
      EMAIL="$EMAIL\n"
      echo -e "$EMAIL" | $MAIL -s ""$SERVERNAME" Disk Usage Alert: Threshold Not Reached" "$MAILID"
  fi
done
