#!/usr/bin/env python

import sys

current_key = None
current_made = 0
current_total = 0
player_stats = {}

# The input comes from standard input (line by line).
for line in sys.stdin:
    line = line.strip()
    key, value = line.split('\t')
    made, total = map(int, value.split(','))

    if key == current_key:
        current_made += made
        current_total += total
    else:
        if current_key:
            player_name, zone = current_key.rsplit('_', 1)
            hit_rate = current_made / current_total
            if player_name not in player_stats:
                player_stats[player_name] = {}
            player_stats[player_name][zone] = hit_rate
        current_key = key
        current_made = made
        current_total = total

# Output the final key if needed
if current_key:
    player_name, zone = current_key.rsplit('_', 1)
    hit_rate = current_made / current_total
    if player_name not in player_stats:
        player_stats[player_name] = {}
    player_stats[player_name][zone] = hit_rate

# Print the best zone for the specific players
for player in ["James Harden", "Chris Paul", "Stephen Curry", "LeBron James"]:
    best_zone = max(player_stats.get(player, {}), key=player_stats.get(player, {}).get)
    print(f'{player}\t{best_zone}\t{player_stats[player][best_zone]}')
