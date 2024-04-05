#!/usr/bin/env python

import sys

# The input comes from standard input (line by line)
for line in sys.stdin:
    line = line.strip()  # Remove leading and trailing whitespace
    fields = line.split()  # Split the line into fields
    
    # Check if we have the correct number of fields
    if len(fields) >= 8:
        issue_date = fields[4]
        vehicle_make = fields[7]
        year = issue_date.split('/')[-1]  # Assuming the date format is mm/dd/yyyy

        # Output the year and vehicle make
        print(f'{year}\t{vehicle_make}\t1')
