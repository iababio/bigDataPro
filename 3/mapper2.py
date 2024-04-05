# Mapper
import sys

def calculate_zone(data):
    # get shot distance, closest defender distance, and shot clock data
    shot_dist = float(data[11])
    close_def_dist = float(data[15])
    shot_clock = float(data[8]) if data[8] != '' else 0  # Handle empty shot clock cases

    # Define boundaries (just an example, you should provide real values)
    # Assume data on 'shot distance' and 'closest defender distance' 
    # are in feet and 'shot clock' is in seconds
    medium_shot_dist = 20
    close_def_dist_threshold = 6
    half_of_shot_clock = 12
    
    # classify shot distance
    if shot_dist <= medium_shot_dist:
        shot_dist_zone = 'low'
    else:
        shot_dist_zone = 'high'
    
    # classify closest defender distance
    if close_def_dist <= close_def_dist_threshold:
        close_def_dist_zone = 'low'
    else:
        close_def_dist_zone = 'high'
        
    # classify shot clock
    if shot_clock <= half_of_shot_clock:
        shot_clock_zone = 'low'
    else:
        shot_clock_zone = 'high'
        
    # concatenate zones
    zone = shot_dist_zone + '_' + close_def_dist_zone + '_' + shot_clock_zone

    return zone


for line in sys.stdin:
    data = line.strip().split('\t')
    player = data[-2]
    shot_result = 1 if data[-6] == 'made' else 0
    comfort_zone = calculate_zone(data)
    print('{}\t{}\t{}\t1'.format(player, comfort_zone, shot_result))
