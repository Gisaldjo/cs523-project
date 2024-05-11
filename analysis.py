#!/usr/bin/env python3

import os
import re
import pandas
import matplotlib.pyplot as plt


def parse_softirq_logs(path, prefix):
    softirq_logs_path = f"logs/{path}/softirq/"
    softirq_logs = os.listdir(softirq_logs_path)

    data = []
    for log_file in softirq_logs:
        with open(softirq_logs_path + log_file, 'r') as f:
            lines = f.readlines()
            for line in lines:
                res = line.split("    ")
                if len(res) == 9:# and res[7] != "0.00":
                    data.append({"Time": res[0], "Log File": log_file, "Value": res[7]})
    df = pandas.DataFrame(data)
    df['Time'] = pandas.to_datetime(df['Time'], format="%I:%M:%S %p")
    df['Value'] = pandas.to_numeric(df['Value'])
    df = df.sort_values('Time')
    plt.figure(figsize=(10, 6))
    plt.plot(df['Time'], df['Value'])

    plt.title(f'(cgroups {prefix}) Softirq Cpu Util over Time')
    plt.xlabel('Time')
    plt.ylabel('Cpu Utilization')

    plt.savefig(f"softirq_cpu_util_{prefix}.png")
    
def parse_sysbench_logs(prefix):
    logs = [p for p in os.listdir("logs/") if p.startswith(prefix)]
    
    data = []
    for path in logs:
        logs_path = f"logs/{path}/"
        sysbench_logs = [p for p in os.listdir(logs_path) if p.startswith("sysbench")]
        
        for log_file in sysbench_logs:
            with open(logs_path + log_file, 'r') as f:
                lines = f.readlines()
                num_of_pods = log_file.split("_")[1].rstrip(".log")
                for line in lines[1:]:
                    if "avg:" in line:
                        avg_latency = re.findall(r'\d+\.\d+', line)[0]
                        data.append({"Num of pods": num_of_pods, "Avg Latency": avg_latency})
    df = pandas.DataFrame(data)
    df['Avg Latency'] = pandas.to_numeric(df['Avg Latency'])
    df['Num of pods'] = pandas.to_numeric(df['Num of pods'])
    df = df.groupby('Num of pods')['Avg Latency'].mean().reset_index()
    df = df.sort_values('Num of pods')
    plt.figure(figsize=(10, 6))
    plt.plot(df['Num of pods'], df['Avg Latency'])

    plt.title(f'(cgroups {prefix.split("_")[1]}) Sysbench Avg Latency vs Number of Netperf Pods')
    plt.xlabel('Num of Netperf Pods')
    plt.ylabel('Sysbench Avg Latency (ms)')

    plt.savefig(f"avg_latency_{prefix}.png")
    
def parse_cpu_util(path, prefix):
    cpu_util_log = f"logs/{path}/cpu_utilization.log"
    if not os.path.exists(cpu_util_log):
        return
    data = []
    with open(cpu_util_log, 'r') as f:
        lines = f.readlines()
        for line in lines:
            if not line or line == "\n":
                continue
            l = line.split(" ")
            util = l[-1].rstrip("%\n")
            time = l[0]
            data.append({"Time": time, "CPU Utilization": util})
    df = pandas.DataFrame(data)
    df['Time'] = pandas.to_datetime(df['Time'], format="%Y.%m.%d-%H.%M.%S")
    df['CPU Utilization'] = pandas.to_numeric(df['CPU Utilization'])
    df = df.sort_values('Time')
    plt.figure(figsize=(10, 6))
    plt.plot(df['Time'], df['CPU Utilization'])

    plt.title(f'(cgroups {prefix}) Total Cpu Util Over Time')
    plt.xlabel('Time')
    plt.ylabel('Total Cpu Utilization %')

    plt.savefig(f"cpu_util_{prefix}.png")

def parse_netperf_throughput(prefix):
    logs = [p for p in os.listdir("logs/") if p.startswith(prefix)]
    
    data = []
    for path in logs:
        logs_path = f"logs/{path}/"
        netperf_logs = [p for p in os.listdir(logs_path) if p.startswith("netperf")]
        
        for log_file in netperf_logs:
            with open(logs_path + log_file, 'r') as f:
                lines = f.readlines()
                num_of_pods = log_file.split("_")[1].rstrip(".log")
                for line in lines:
                    values = re.findall(r'\b\d+\.\d+\b|\b\d+\b', line)
                    if len(values) == 5:
                        throughput = values[-1]
                        data.append({"Num of pods": num_of_pods, "Throughput": throughput})

    df = pandas.DataFrame(data)
    df['Throughput'] = pandas.to_numeric(df['Throughput'])
    df['Num of pods'] = pandas.to_numeric(df['Num of pods'])
    df = df.groupby('Num of pods')['Throughput'].mean().reset_index()
    df = df.sort_values('Num of pods')
    plt.figure(figsize=(10, 6))
    plt.plot(df['Num of pods'], df['Throughput'])

    plt.title(f'(cgroups {prefix.split("_")[1]}) Netperf Network Throughput vs Number of Pods')
    plt.xlabel('Num of Pods')
    plt.ylabel('Avg Network Throughput Per Pod (mbps)')
    plt.xticks([20, 40, 60, 80])
    plt.savefig(f"throughput_{prefix}.png")
    
if __name__ == "__main__":
    v2_path = "mixed_v2_2024-05-10_205439"
    v1_path = "mixed_v1_2024-05-10_205423"
    parse_softirq_logs(v2_path, "v2")
    parse_softirq_logs(v1_path, "v1")
    parse_cpu_util(v2_path, "v2")
    parse_cpu_util(v1_path, "v1")
    parse_netperf_throughput("network_v2")
    parse_netperf_throughput("network_v1")
    parse_sysbench_logs("mixed_v1")
    parse_sysbench_logs("mixed_v2")
