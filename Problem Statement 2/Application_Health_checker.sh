#!/bin/bash


APP_URL="http://example.com"  
LOG_FILE="/var/log/uptime.log" 
STATUS_UP=200               


log_message() {
    local message=$1
    echo "$(date) - $message" | tee -a $LOG_FILE
}


check_application_status() {
    local status_code=$(curl -s -o /dev/null -w "%{http_code}" "$APP_URL")

    if [ "$status_code" -eq "$STATUS_UP" ]; then
        log_message "Application is UP. Status code: $status_code"
        echo "Application is UP. Status code: $status_code"
    else
        log_message "Application is DOWN. Status code: $status_code"
        echo "Application is DOWN. Status code: $status_code"
    fi
}


main() {
    echo "Checking application status for URL: $APP_URL"
    check_application_status
}


main
