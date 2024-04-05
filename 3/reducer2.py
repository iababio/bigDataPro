# Reducer
import sys


current_pair = None
total_shots = 0
made_shots = 0

for line in sys.stdin:
    data = line.strip().split('\t')
    pair = data[0], data[1]
    shot_result, count = map(int, data[2:])

    if current_pair and current_pair != pair:
        hit_rate = 1.0 * made_shots / total_shots
        print('%s\t%s\t%s' % (current_pair[0], current_pair[1], hit_rate))

        made_shots = shot_result
        total_shots = count
    else:
        made_shots += shot_result
        total_shots += count
        
    current_pair = pair

if current_pair:
    hit_rate = 1.0 * made_shots / total_shots
    print('%s\t%s\t%s' % (current_pair[0], current_pair[1], hit_rate))
