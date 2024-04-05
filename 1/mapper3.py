#!/usr/bin/env python

import sys

# The input comes from standard input (line by line)
for line in sys.stdin:
    line = line.strip()  # Remove leading and trailing whitespace
    fields = line.split()  # Split the line into fields

    # Assuming the street code is the last field
    # Check if we have a non-empty line and enough fields
    if fields and len(fields) >= 9:
        street_code = fields[-1]  # Get the last field as street code
        
        # Output the street code with a count of 1
        print(f'{street_code}\t1')
