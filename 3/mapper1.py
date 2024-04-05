# Mapper
import sys


for line in sys.stdin:
    data = line.strip().split('\t')
    player = data[-2]
    defender = data[-5]
    shot_result = 1 if data[-6] == 'made' else 0
    print(f'{player}\t{defender}\t{shot_result}\t1')
