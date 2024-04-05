#!/usr/bin/env python

import sys
from collections import defaultdict

current_date = None
current_count = 0
date_count = defaultdict(int)

# The input comes from standard input (line by line)
for line in sys.stdin:
    line = line.strip()  # remove leading and trailing whitespace
    date, count = line.split('\t', 1)  # split the line into key/value

    try:
        count = int(count)  # convert count (currently a string) to int
    except ValueError:
        continue

    if current_date == date:
        current_count += count
    else:
        if current_date:
            # write result to standard output
            print(f'{current_date}\t{current_count}')
        current_date = date
        current_count = count

# output the last date if needed
if current_date == date:
    print(f'{current_date}\t{current_count}')
