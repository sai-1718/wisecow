#!/bin/bash


CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80
PROCESS_THRESHOLD=80


LOG_FILE="/var/log/system_health.log"


touch $LOG_FILE

log_alert() {
    local message=$1
    echo "$(date) - $message" | tee -a $LOG_FILE
}

check_cpu_usage() {
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    cpu_usage=${cpu_usage%.*} 
    if [ "$cpu_usage" -gt "$CPU_THRESHOLD" ]; then
        log_alert "High CPU usage detected: ${cpu_usage}%"
    else
        echo "CPU usage is normal: ${cpu_usage}%"
    fi
}

check_memory_usage() {
    local memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    memory_usage=${memory_usage%.*} 
    if [ "$memory_usage" -gt "$MEMORY_THRESHOLD" ]; then
        log_alert "High Memory usage detected: ${memory_usage}%"
    else
        echo "Memory usage is normal: ${memory_usage}%"
    fi
}

check_disk_usage() {
    local disk_usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
    if [ "$disk_usage" -gt "$DISK_THRESHOLD" ]; then
        log_alert "High Disk usage detected: ${disk_usage}% on root partition"
    else
        echo "Disk usage is normal: ${disk_usage}%"
    fi
}

check_running_processes() {
    local process_count=$(ps aux | wc -l)
    if [ "$process_count" -gt "$PROCESS_THRESHOLD" ]; then
        log_alert "High number of running processes detected: $process_count"
    else
        echo "Number of running processes is normal: $process_count"
    fi
}

main() {
    echo "Starting system health check..."
    check_cpu_usage
    check_memory_usage
    check_disk_usage
    check_running_processes
    echo "System health check completed."
}

main
