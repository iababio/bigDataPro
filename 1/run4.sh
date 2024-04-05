#!/bin/bash

# INPUT=/path/to/the/dataset4
# OUTPUT=/path/to/output4
# MAPPER=/path/to/mapper4.py
# REDUCER=/path/to/reducer4.py

# # Remove output directory if it already exists
# hdfs dfs -rm -r $OUTPUT

# hadoop jar /path/to/hadoop-streaming.jar \
# -file $MAPPER    -mapper $MAPPER \
# -file $REDUCER   -reducer $REDUCER \
# -input $INPUT \
# -output $OUTPUT


#!/bin/sh
../../start.sh
/usr/local/hadoop/bin/hdfs dfs -rm -r /path/to/output4/
/usr/local/hadoop/bin/hdfs dfs -mkdir -p /path/to/the/dataset4/
/usr/local/hadoop/bin/hdfs dfs -copyFromLocal /path/to/local/dataset4 /path/to/the/dataset4/
/usr/local/hadoop/bin/hadoop jar /usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.1.jar \
-file /path/to/mapper4.py   -mapper /path/to/mapper4.py \
-file /path/to/reducer4.py  -reducer /path/to/reducer4.py \
-input /path/to/the/dataset4/* -output /path/to/output4/
/usr/local/hadoop/bin/hdfs dfs -cat /path/to/output4/part-00000
/usr/local/hadoop/bin/hdfs dfs -rm -r /path/to/the/dataset4/
/usr/local/hadoop/bin/hdfs dfs -rm -r /path/to/output4/
../../stop.sh
