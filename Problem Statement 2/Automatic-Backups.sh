#!/bin/bash


SOURCE_DIR="/path/to/source"   
REMOTE_USER="remote-server-username"         
REMOTE_HOST="remote.server.com" 
REMOTE_DIR="/path/to/backup"   
LOG_FILE="/var/log/backup.log"


USE_S3=false                   
S3_BUCKET="your-s3-bucket"     
S3_PATH="backup/"              


log_message() {
    local message=$1
    echo "$(date) - $message" | tee -a $LOG_FILE
}


perform_backup() {
    if [ "$USE_S3" = true ]; then
    
        log_message "Starting backup to AWS S3..."
        aws s3 sync "$SOURCE_DIR" "s3://$S3_BUCKET/$S3_PATH" --delete
        if [ $? -eq 0 ]; then
            log_message "Backup to AWS S3 completed successfully."
        else
            log_message "Backup to AWS S3 failed."
            exit 1
        fi
    else
     
        log_message "Starting backup to remote server..."
        rsync -avz --delete "$SOURCE_DIR" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"
        if [ $? -eq 0 ]; then
            log_message "Backup to remote server completed successfully."
        else
            log_message "Backup to remote server failed."
            exit 1
        fi
    fi
}


main() {
    log_message "Backup operation started."
    perform_backup
    log_message "Backup operation completed."
}


main
