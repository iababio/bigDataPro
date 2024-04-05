#!/usr/bin/env python

import sys

def classify_zone(shot_dist, close_def_dist, shot_clock):
    # Define zones based on the given criteria
    if shot_dist < 10 and close_def_dist > 3 and shot_clock > 15:
        return 1
    elif 10 <= shot_dist <= 20 and close_def_dist <= 3 and shot_clock > 15:
        return 2
    elif shot_dist > 20 and close_def_dist > 3 and shot_clock <= 15:
        return 3
    else:
        return 4

# The input comes from standard input (line by line).
for line in sys.stdin:
    line = line.strip()
    fields = line.split(',')
    
    if len(fields) < 13 or 'SHOT_DIST' in fields:
        continue  # Skip the header and any malformed lines.
    
    player_name = fields[18]
    shot_made = 1 if fields[10] == 'made' else 0
    shot_dist = float(fields[11])
    close_def_dist = float(fields[13])
    shot_clock = float(fields[9])

    zone = classify_zone(shot_dist, close_def_dist, shot_clock)

    print(f'{player_name}_{zone}\t{shot_made},1')
