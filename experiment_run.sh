./cpu_utilization.sh &
CPU_UTIL_PID=$!
./softirq.sh &
# for i in {1..8}
for i in $(seq 20 20 80)
do
    echo "---------------------"
    echo "$(date) - Running experiment round $i"
    echo "---------------------"
    cd network_experiment
    ./run.sh $i

    # cd ../cpu_experiment
    # ./run.sh $i
    cd ../
    sleep 30
    while [ $(sudo docker ps -a | wc -l) -gt 2 ]
    do
        sleep 10
    done
done

killall pidstat
kill $CPU_UTIL_PID
