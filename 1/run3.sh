#!/bin/bash

# INPUT=/path/to/the/dataset3
# OUTPUT=/path/to/output3
# MAPPER=/path/to/mapper3.py
# REDUCER=/path/to/reducer3.py

# # Remove output directory if it already exists
# hdfs dfs -rm -r $OUTPUT

# hadoop jar /path/to/hadoop-streaming.jar \
# -file $MAPPER    -mapper $MAPPER \
# -file $REDUCER   -reducer $REDUCER \
# -input $INPUT \
# -output $OUTPUT



#!/bin/sh
../../start.sh
/usr/local/hadoop/bin/hdfs dfs -rm -r /path/to/output3/
/usr/local/hadoop/bin/hdfs dfs -mkdir -p /path/to/the/dataset3/
/usr/local/hadoop/bin/hdfs dfs -copyFromLocal /path/to/local/dataset3 /path/to/the/dataset3/
/usr/local/hadoop/bin/hadoop jar /usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.1.jar \
-file /path/to/mapper3.py    -mapper /path/to/mapper3.py \
-file /path/to/reducer3.py   -reducer /path/to/reducer3.py \
-input /path/to/the/dataset3/* -output /path/to/output3/
/usr/local/hadoop/bin/hdfs dfs -cat /path/to/output3/part-00000
/usr/local/hadoop/bin/hdfs dfs -rm -r /path/to/the/dataset3/
/usr/local/hadoop/bin/hdfs dfs -rm -r /path/to/output3/
../../stop.sh
