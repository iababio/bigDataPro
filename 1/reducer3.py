#!/usr/bin/env python

import sys

current_street_code = None
current_count = 0

# The input comes from standard input (line by line)
for line in sys.stdin:
    line = line.strip()  # Remove leading and trailing whitespace
    street_code, count = line.split('\t', 1)  # Split the line into key/value

    try:
        count = int(count)  # Convert count (currently a string) to int
    except ValueError:
        continue

    # If the current street code is the same as the last one we processed
    if current_street_code == street_code:
        current_count += count
    else:
        if current_street_code:
            # Write result to standard output
            print(f'{current_street_code}\t{current_count}')
        current_street_code = street_code
        current_count = count

# Output the last street code if needed
if current_street_code == street_code:
    print(f'{current_street_code}\t{current_count}')
