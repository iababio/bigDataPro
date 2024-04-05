#!/usr/bin/env python

import sys

# The input comes from standard input (line by line)
for line in sys.stdin:
    line = line.strip()  # remove leading and trailing whitespace
    fields = line.split()  # split the line into fields
    
    # Check if we have the correct number of fields
    if len(fields) == 10:
        # Extract the issue date
        issue_date = fields[4]
        print(f'{issue_date}\t1')
