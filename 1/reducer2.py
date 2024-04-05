#!/usr/bin/env python

import sys
from collections import defaultdict

year_make_count = defaultdict(int)

# The input comes from standard input (line by line)
for line in sys.stdin:
    line = line.strip()  # Remove leading and trailing whitespace
    year_make, count = line.split('\t', 2)  # Split the line into key and value

    try:
        count = int(count)  # Convert count (currently a string) to int
    except ValueError:
        continue

    year_make_count[year_make] += count

# Output the count for each year and make
for year_make, count in year_make_count.items():
    year, make = year_make.split('\t')
    print(f'{year}\t{make}\t{count}')
