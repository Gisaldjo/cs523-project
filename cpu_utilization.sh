echo "" > cpu_utilization.log
while true; do
    timestamp=$(date "+%Y.%m.%d-%H.%M.%S")
    utilization=$(mpstat 1 1 | awk '/Average:/ && $2 ~ /all/ { print 100 - $NF }')
    echo "$timestamp - CPU Utilization : $utilization%" >> cpu_utilization.log
    sleep 3
done
