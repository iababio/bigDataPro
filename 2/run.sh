#!/bin/sh

# Define paths to Hadoop binary, input, output, mapper, and reducer
HADOOP_STREAMING_JAR_PATH=/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.1.jar
HDFS_INPUT_PATH=/user/hadoop/input
HDFS_OUTPUT_PATH=/user/hadoop/output
LOCAL_MAPPER_PATH=/home/hadoop/mapper1.py
LOCAL_REDUCER_PATH=/home/hadoop/reducer1.py

# Start the Hadoop cluster
../../start.sh

# Remove the output directory if it already exists
/usr/local/hadoop/bin/hdfs dfs -rm -r $HDFS_OUTPUT_PATH

# Run the MapReduce job
/usr/local/hadoop/bin/hadoop jar $HADOOP_STREAMING_JAR_PATH \
-file $LOCAL_MAPPER_PATH    -mapper $LOCAL_MAPPER_PATH \
-file $LOCAL_REDUCER_PATH   -reducer $LOCAL_REDUCER_PATH \
-input $HDFS_INPUT_PATH/* -output $HDFS_OUTPUT_PATH

# Output the results to the local file system
/usr/local/hadoop/bin/hdfs dfs -cat $HDFS_OUTPUT_PATH/part-* > /home/hadoop/output.txt

# Remove the input and output directories from HDFS
/usr/local/hadoop/bin/hdfs dfs -rm -r $HDFS_INPUT_PATH
/usr/local/hadoop/bin/hdfs dfs -rm -r $HDFS_OUTPUT_PATH

# Stop the Hadoop cluster
../../stop.sh

# End of script
