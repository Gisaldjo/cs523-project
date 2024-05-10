./cpu_utilization.sh &
./softirq.sh &
# for i in {1..8}
for i in $(seq 5 5 20)
do
    echo "---------------------"
    echo "$(date) - Running experiment round $i"
    echo "---------------------"
    cd network_experiment
    ./run.sh $i

    # cd ../cpu_experiment
    # ./run.sh $i
    cd ../
    while [ $(sudo docker ps -a | wc -l) -gt 2 ]
    do
        sleep 10
    done
done

killall pidstat
