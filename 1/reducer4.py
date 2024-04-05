#!/usr/bin/env python

import sys

current_color = None
current_count = 0

for line in sys.stdin:
    line = line.strip()
    color, count = line.split('\t')

    try:
        count = int(count)
    except ValueError:
        continue

    if current_color == color:
        current_count += count
    else:
        if current_color:
            print(f'{current_color}\t{current_count}')
        current_color = color
        current_count = count

if current_color == color:  # Output the last color if needed
    print(f'{current_color}\t{current_count}')
