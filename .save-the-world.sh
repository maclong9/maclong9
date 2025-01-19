#!/bin/sh

# Run curl requests in parallel for multiple URLs
run_curl() {
    url=$1
    task_num=$2
    for i in $(seq 1 100); do
        curl -s "$url" > /dev/null
        echo "Task $task_num - Count: $i"
        sleep 5
    done
}

# URLs to process
urls="https://www.ecosia.org/search?q=maclong9%2Fdots
https://oceanhero.today/web?q=maclong9%2Fdots"

# Launch parallel tasks
task_num=1
echo "$urls" | while read -r url; do
    run_curl "$url" "$task_num" &
    task_num=$((task_num + 1))
done

# Wait for all background tasks to complete
wait
