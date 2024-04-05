#!/usr/bin/env python

import sys

for line in sys.stdin:
    line = line.strip()
    fields = line.split()
    if len(fields) > 7:  # Assuming color is the eighth field
        vehicle_color = fields[7]
        print(f'{vehicle_color}\t1')
