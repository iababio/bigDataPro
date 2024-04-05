#!/bin/bash

# HADOOP_STREAMING_PATH=/path/to/hadoop-streaming.jar
# INPUT_PATH=/path/to/input_directory_in_hdfs
# INTERMEDIATE_PATH=/path/to/intermediate_directory_in_hdfs
# OUTPUT_PATH=/path/to/output_directory_in_hdfs
# MAPPER1_PATH=/path/to/mapper1.py
# REDUCER1_PATH=/path/to/reducer1.py
# MAPPER2_PATH=/path/to/mapper2.py
# REDUCER2_PATH=/path/to/reducer2.py

# # removes directories if they already exists
# hadoop fs -rm -r $INTERMEDIATE_PATH
# hadoop fs -rm -r $OUTPUT_PATH

# # launch the first Hadoop streaming job
# hadoop jar $HADOOP_STREAMING_PATH \
# -input $INPUT_PATH \
# -output $INTERMEDIATE_PATH \
# -mapper $MAPPER1_PATH \
# -reducer $REDUCER1_PATH \
# -file $MAPPER1_PATH \
# -file $REDUCER1_PATH

# # launch the second Hadoop streaming job
# hadoop jar $HADOOP_STREAMING_PATH \
# -input $INTERMEDIATE_PATH \
# -output $OUTPUT_PATH \
# -mapper $MAPPER2_PATH \
# -reducer $REDUCER2_PATH \
# -file $MAPPER2_PATH \
# -file $REDUCER2_PATH



#!/bin/sh
../../start.sh
/usr/local/hadoop/bin/hdfs dfs -rm -r /path/to/intermediate_directory_in_hdfs/
/usr/local/hadoop/bin/hdfs dfs -rm -r /path/to/output_directory_in_hdfs/
/usr/local/hadoop/bin/hdfs dfs -mkdir -p /path/to/input_directory_in_hdfs/
/usr/local/hadoop/bin/hdfs dfs -copyFromLocal /path/to/local/input_data /path/to/input_directory_in_hdfs/
/usr/local/hadoop/bin/hadoop jar /usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.1.jar \
-file /path/to/mapper1.py   -mapper /path/to/mapper1.py \
-file /path/to/reducer1.py  -reducer /path/to/reducer1.py \
-input /path/to/input_directory_in_hdfs/* -output /path/to/intermediate_directory_in_hdfs/
/usr/local/hadoop/bin/hadoop jar /usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.1.jar \
-file /path/to/mapper2.py   -mapper /path/to/mapper2.py \
-file /path/to/reducer2.py  -reducer /path/to/reducer2.py \
-input /path/to/intermediate_directory_in_hdfs/* -output /path/to/output_directory_in_hdfs/
/usr/local/hadoop/bin/hdfs dfs -cat /path/to/output_directory_in_hdfs/part-00000
/usr/local/hadoop/bin/hdfs dfs -rm -r /path/to/input_directory_in_hdfs/
/usr/local/hadoop/bin/hdfs dfs -rm -r /path/to/intermediate_directory_in_hdfs/
/usr/local/hadoop/bin/hdfs dfs -rm -r /path/to/output_directory_in_hdfs/
../../stop.sh
