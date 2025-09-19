#!/usr/bin/env python3
import sys
import matplotlib.pyplot as plt
from cpu_time_to_seconds import parse_cpu_time, get_cpu_times


def main():
    import argparse
    parser = argparse.ArgumentParser(description='Plot CPU times from log file.')
    parser.add_argument('input_file', help='Input log file')
    parser.add_argument('--labels', nargs=2, metavar=('LABEL1', 'LABEL2'), default=['Exp', 'vanilla'], help='Labels for paired mode')
    parser.add_argument('--mode', choices=['pair', 'independent'], default='pair', help='Plot as pairs or independently')
    args = parser.parse_args()

    times = get_cpu_times(args.input_file)

    plt.figure(figsize=(10, 6))
    if args.mode == 'pair':
        pairs = [(times[i], times[i+1]) for i in range(0, len(times)-1, 2)]
        pair1 = [a for a, b in pairs]
        pair2 = [b for a, b in pairs]
        x = range(len(pairs))
        bar_width = 0.4
        plt.bar([i - bar_width/2 for i in x], pair1, width=bar_width, color='blue', label=args.labels[0])
        plt.bar([i + bar_width/2 for i in x], pair2, width=bar_width, color='orange', label=args.labels[1])
        plt.xlabel('Pair Index')
        plt.ylabel('CPU Time (seconds)')
        plt.title('CPU Time Used (Consecutive Pairs)')
        plt.legend()
    else:
        x = range(len(times))
        plt.bar(x, times, color='green')
        plt.xlabel('Index')
        plt.ylabel('CPU Time (seconds)')
        plt.title('CPU Time Used (Independent Values)')
    plt.tight_layout()
    plt.show()

if __name__ == "__main__":
    main()
