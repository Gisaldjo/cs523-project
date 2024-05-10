#!/usr/bin/env python3

import os

softirq_logs_path = "softirq_logs/"
softirq_logs = os.listdir(softirq_logs_path)
for log_file in softirq_logs:
    with open(softirq_logs_path + log_file, 'r') as f:
        lines = f.readlines()
        for line in lines:
            res = line.split("    ")
            if len(res) == 9 and res[7] != "0.00":
                print(f"{log_file}: {res[7]}")
