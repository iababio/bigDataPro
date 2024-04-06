# Mapper
import sys


for line in sys.stdin:
    data = line.strip().split('\t')
    player = data[-2]
    defender = data[-5]
    shot_result = 1 if data[-6] == 'made' else 0
    print(f'{player}\t{defender}\t{shot_result}\t1')




import sys
import csv

def map_function():
    reader = csv.reader(sys.stdin, quotechar='"')
    i = 0  # Initialize counter to keep track of the line number manually
    for line in reader:
        try:
            shooter = line[21].strip()
            defender = line[16].strip()
            outcome = line[13].strip().lower()
            made = '1' if outcome == 'made' else '0'

            print("{}_{}\t{}".format(shooter, defender, made))
        except Exception as e:
            sys.stderr.write("Error in line {}: {}, Content: {}\n".format(i, e, ','.join(line[:5])))
        i += 1  # Increment the counter at the end of each loop iteration

if __name__ == "__main__":
    map_function()
