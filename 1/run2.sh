#!/bin/bash

# INPUT=/path/to/the/dataset2
# OUTPUT=/path/to/output2
# MAPPER=/path/to/mapper2.py
# REDUCER=/path/to/reducer2.py

# # Remove output directory if it already exists
# hdfs dfs -rm -r $OUTPUT

# hadoop jar /path/to/hadoop-streaming.jar \
# -file $MAPPER    -mapper $MAPPER \
# -file $REDUCER   -reducer $REDUCER \
# -input $INPUT \
# -output $OUTPUT


#!/bin/sh
../../start.sh
/usr/local/hadoop/bin/hdfs dfs -rm -r /path/to/output2/
/usr/local/hadoop/bin/hdfs dfs -mkdir -p /path/to/the/dataset2/
/usr/local/hadoop/bin/hdfs dfs -copyFromLocal /path/to/local/dataset2 /path/to/the/dataset2/
/usr/local/hadoop/bin/hadoop jar /usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.1.jar \
-file /path/to/mapper2.py    -mapper /path/to/mapper2.py \
-file /path/to/reducer2.py   -reducer /path/to/reducer2.py \
-input /path/to/the/dataset2/* -output /path/to/output2/
/usr/local/hadoop/bin/hdfs dfs -cat /path/to/output2/part-00000
/usr/local/hadoop/bin/hdfs dfs -rm -r /path/to/the/dataset2/
/usr/local/hadoop/bin/hdfs dfs -rm -r /path/to/output2/
../../stop.sh
