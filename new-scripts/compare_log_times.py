#!/usr/bin/env python3
import sys
import matplotlib.pyplot as plt
from cpu_time_to_seconds import get_cpu_times

def main():
    if len(sys.argv) < 3 or len(sys.argv) > 5:
        print(f"Usage: {sys.argv[0]} <log_file1> <log_file2> [label1] [label2]")
        sys.exit(1)
    log_file1 = sys.argv[1]
    log_file2 = sys.argv[2]
    label1 = sys.argv[3] if len(sys.argv) > 3 else 'Log1'
    label2 = sys.argv[4] if len(sys.argv) > 4 else 'Log2'
    times1 = get_cpu_times(log_file1)
    times2 = get_cpu_times(log_file2)
    x1 = range(len(times1))
    x2 = range(len(times2))
    plt.figure(figsize=(12, 6))
    plt.bar(x1, times1, width=0.4, color='blue', label=label1)
    plt.bar([i + 0.45 for i in x2], times2, width=0.4, color='orange', label=label2)
    plt.xlabel('Index')
    plt.ylabel('CPU Time (seconds)')
    plt.title('Comparison of CPU Times from Two Log Files')
    plt.legend()
    plt.tight_layout()
    plt.show()

if __name__ == "__main__":
    main()
