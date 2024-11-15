#!/usr/bin/env bash

set -e

LOG_FILE="${LOG_FILE:-/var/log/nginx/access.log}"

status_codes() {
    echo "Summary of http status code:"
    awk '{ print $9 }' "$LOG_FILE" | sort | uniq -c
}

requested_pages() {
    echo "Top 10 most requested pages:"
    awk '{ print $7 }' "$LOG_FILE" | sort | uniq -c | sort -r |  head -10
}

ip_address_with_most_request() {
    echo "Top 10 ip address with the most requests:"
    awk '{ print $1 }' "$LOG_FILE" | sort | uniq -c | head -10
}

user_agents_with_most_request() {
    echo "Top 10 user-agents with the most request:"
 
    awk -F '"' '{ print $6 }' "$LOG_FILE" | sort | uniq -c | head -10
}


prerequisites=(
    awk
    sort
    uniq
    head
)

proceed=true
for bin in "${prerequisites[@]}"; do
    if [[ -z "$(command -v "$bin")" ]]; then
        echo "$bin not found on the system"
        proceed=false
    fi
done
if [[ "$proceed" != true ]]; then
    exit 1
fi

if [[ ! -f "$LOG_FILE" ]]; then
    echo "file not found: $LOG_FILE"
    exit 1
fi

status_codes
requested_pages
ip_address_with_most_request
user_agents_with_most_request