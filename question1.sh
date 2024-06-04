#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 path_to_log_file"
    exit 1
fi

log_file="$1"

# Check if the log file exists and is readable
if [ ! -f "$log_file" ] || [ ! -r "$log_file" ]; then
    echo "Error: Log file does not exist or is not readable."
    exit 1
fi

# Total number of requests
total_requests=$(wc -l < "$log_file")

# Number of successful requests (status code 200-299)
successful_requests=$(awk '$9 ~ /^2[0-9][0-9]$/' "$log_file" | wc -l)

# Calculate percentage of successful requests
if [ "$total_requests" -eq 0 ]; then
    success_percentage=0
else
    success_percentage=$(echo "scale=2; ($successful_requests / $total_requests) * 100" | bc)
fi

# Most active user (IP address with the most requests)
most_active_user=$(awk '{print $1}' "$log_file" | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')

# Output the results
echo "Total Requests Count: $total_requests"
echo "Percentage of Successful Requests: $success_percentage%"
echo "Most Active User: $most_active_user"
