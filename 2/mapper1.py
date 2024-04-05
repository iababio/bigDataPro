#!/usr/bin/env python

import sys

# The input comes from standard input (line by line).
for line in sys.stdin:
    line = line.strip()  # Remove leading and trailing whitespace.
    fields = line.split(',')  # Split the line into fields.
    
    # Check if we have a header or not enough fields.
    if fields[0] == "GAME_ID" or len(fields) < 19:
        continue  # Skip the header and any malformed lines.
    
    shooter = fields[18]  # Assuming the shooter's name is in the 19th field.
    defender = fields[16]  # Assuming the defender's name is in the 17th field.
    shot_made = fields[10]  # Assuming 'SHOT_RESULT' is in the 11th field and it contains 'made' or 'missed'.

    # Check if the shot was made or missed.
    made = 1 if shot_made == 'made' else 0
    
    # Output the key-value pair.
    print(f'{shooter},{defender}\t{made},1')
