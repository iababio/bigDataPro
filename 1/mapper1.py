

#!/usr/bin/env python
"""mapper.py"""

import sys
import math

def load_current_centroids():
    # This function would load the centroids from a file or some other storage
    # For this example, let's assume it's hardcoded
    return [
        (5, 3, 15),  # Example centroid for Zone 1
        (15, 2, 18),  # Example centroid for Zone 2
        (25, 5, 8),  # Example centroid for Zone 3
        (20, 6, 5),  # Example centroid for Zone 4
    ]

def euclidean_distance(point1, point2):
    """Calculate the Euclidean distance between two points in 3D space."""
    return math.sqrt(sum([(a - b) ** 2 for a, b in zip(point1, point2)]))

def find_nearest_centroid(shot_dist, close_def_dist, shot_clock, centroids):
    """Find the nearest centroid for a given shot."""
    min_distance = float('inf')  # Start with an infinitely large distance
    nearest_centroid_id = None
    shot_point = (shot_dist, close_def_dist, shot_clock)
    
    # Iterate through each centroid and calculate the distance to the shot point
    for centroid_id, centroid in enumerate(centroids):
        distance = euclidean_distance(shot_point, centroid)
        # If this centroid is closer than the previous closest, update the nearest centroid
        if distance < min_distance:
            nearest_centroid_id = centroid_id
            min_distance = distance
            
    return nearest_centroid_id




# Load the current centroids (these would be updated between MapReduce runs)
centroids = load_current_centroids()


for line in sys.stdin:
    line = line.strip()
    # Assume that the columns are ordered as mentioned and that this script is
    # being run in a secure environment where input format is guaranteed.
    fields = line.split(',')
    
    if len(fields) < 13 or 'SHOT_DIST' in fields:
        continue  # Skip the header and any malformed lines.
    
    shooter = fields[18]
    defender = fields[16]
    shot_made = 1 if fields[10] == 'made' else 0
    shot_dist = float(fields[11])
    close_def_dist = float(fields[13])
    shot_clock = float(fields[9])

    # Assign shot to the nearest centroid
    centroid_id = find_nearest_centroid(shot_dist, close_def_dist, shot_clock, centroids)

    # Emit tuple (shooter, defender) as key and (centroid_id, shot_made, 1) as value
    print(f'{shooter},{defender}\t{centroid_id},{shot_made},1')
