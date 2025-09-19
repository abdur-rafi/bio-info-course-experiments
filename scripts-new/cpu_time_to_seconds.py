# New function for reuse

def get_cpu_times(input_file):
    times = []
    with open(input_file, 'r') as f:
        for line in f:
            line = line.strip()
            if line.startswith('CPU time used:'):
                total_seconds = parse_cpu_time(line)
                if total_seconds is not None:
                    times.append(total_seconds)
    return times
#!/usr/bin/env python3
import sys
import re

def parse_cpu_time(line):
    match = re.search(r'CPU time used: (\d+) minutes, (\d+) seconds', line)
    if match:
        minutes = int(match.group(1))
        seconds = int(match.group(2))
        total_seconds = minutes * 60 + seconds
        return total_seconds
    return None

def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <input_file>")
        sys.exit(1)
    input_file = sys.argv[1]
    with open(input_file, 'r') as f:
        for line in f:
            line = line.strip()
            if line.startswith('CPU time used:'):
                total_seconds = parse_cpu_time(line)
                if total_seconds is not None:
                    print(total_seconds)

if __name__ == "__main__":
    main()
