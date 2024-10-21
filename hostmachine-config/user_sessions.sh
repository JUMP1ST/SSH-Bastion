#!/bin/bash

# This script is added to /etc/profile to record all commands run by users

# Ensure that only users with interactive sessions are recorded
if [[ -n "$PS1" && "$TERM" != "dumb" ]]; then
    # Create a log file with a timestamp and the user's name to track the session
    LOG_DIR="/var/log/user_sessions"
    LOG_FILE="${LOG_DIR}/$(date "+%Y%m%d_%H%M%S")_${USER}.log"

    # Ensure the log directory exists and set appropriate permissions
    if [[ ! -d "$LOG_DIR" ]]; then
        mkdir -p "$LOG_DIR"
        chmod 750 "$LOG_DIR"  # Restrict access to the log directory
    fi

    # Set proper permissions for the log file
    touch "$LOG_FILE"
    chmod 640 "$LOG_FILE"  # Allow read/write for owner, read for group

    # Start recording the user's commands and log the session quietly
    /usr/bin/script -q -f "$LOG_FILE"

    # Forward the log to an OpenSearch host
    OPENSEARCH_HOST="http://opensearch.example.com:9200"
    INDEX_NAME="user_sessions"
    curl -X POST "$OPENSEARCH_HOST/$INDEX_NAME/_doc" -H "Content-Type: application/json" -d @"$LOG_FILE" &>/dev/null &
fi
