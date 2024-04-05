#!/usr/bin/env python

import sys

current_key = None
current_made = 0
current_total = 0
worst_defender = None
worst_defender_fear_score = 1  # Initialize to 1 (100% shots made).

for line in sys.stdin:
    line = line.strip()  # Remove leading and trailing whitespace.
    key, value = line.split('\t', 1)  # Split the line into key and value.
    made, total = map(int, value.split(','))  # Split the value into 'made' and 'total' shots.

    # If the current key is the same as the last key, we accumulate the counts.
    if key == current_key:
        current_made += made
        current_total += total
    else:
        # If the key has changed (and it's not the first line), we compute the fear score.
        if current_key:
            fear_score = current_made / current_total
            # Extract the shooter from the current key.
            shooter = current_key.split(',')[0]
            # If the fear score is worse than the worst so far, update the worst defender.
            if fear_score < worst_defender_fear_score:
                worst_defender = current_key.split(',')[1]
                worst_defender_fear_score = fear_score
            # Output the previous shooter's worst defender.
            if shooter != current_key.split(',')[0]:
                print(f'{shooter}\t{worst_defender},{worst_defender_fear_score}')
                worst_defender_fear_score = 1  # Reset for the next shooter.

        current_key = key
        current_made = made
        current_total = total

# Output the final shooter's worst defender if needed.
if current_key:
    shooter = current_key.split(',')[0]
    print(f'{shooter}\t{worst_defender},{worst_defender_fear_score}')
