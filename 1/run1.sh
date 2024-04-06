#!/bin/bash

# INPUT=/path/to/the/dataset1
# OUTPUT=/path/to/output1
# MAPPER=/path/to/mapper1.py
# REDUCER=/path/to/reducer1.py

# # Remove output directory if it already exists
# hdfs dfs -rm -r $OUTPUT

# hadoop jar /path/to/hadoop-streaming.jar \
# -file $MAPPER    -mapper $MAPPER \
# -file $REDUCER   -reducer $REDUCER \
# -input $INPUT \
# -output $OUTPUT



#!/bin/sh
../../start.sh
/usr/local/hadoop/bin/hdfs dfs -rm -r /path/to/output1/
/usr/local/hadoop/bin/hdfs dfs -mkdir -p /path/to/the/dataset1/
/usr/local/hadoop/bin/hdfs dfs -copyFromLocal /path/to/local/dataset /path/to/the/dataset1/
/usr/local/hadoop/bin/hadoop jar /usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.1.jar \
-file /path/to/mapper1.py   -mapper /path/to/mapper1.py \
-file /path/to/reducer1.py  -reducer /path/to/reducer1.py \
-input /path/to/the/dataset1/* -output /path/to/output1/
/usr/local/hadoop/bin/hdfs dfs -cat /path/to/output1/part-00000
/usr/local/hadoop/bin/hdfs dfs -rm -r /path/to/the/dataset1/
/usr/local/hadoop/bin/hdfs dfs -rm -r /path/to/output1/
../../stop.sh





#!/bin/sh
# Start Hadoop services (adjust the path to your Hadoop installation and startup script if necessary)
../../start.sh

# Removing existing HDFS directories for input and output to ensure a clean slate for running the MapReduce job
/usr/local/hadoop/bin/hdfs dfs -rm -r /nba/input/
/usr/local/hadoop/bin/hdfs dfs -rm -r /nba/output/

# Creating a new input directory in HDFS
/usr/local/hadoop/bin/hdfs dfs -mkdir -p /nba/input/

# Copy the shot_logs.csv from the local filesystem to the input directory in HDFS
/usr/local/hadoop/bin/hdfs dfs -copyFromLocal ../../mapreduce-test-data/shot_logs.csv /nba/input/

# Execute the Hadoop streaming job
/usr/local/hadoop/bin/hadoop jar /usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.1.jar \
-file ../../mapreduce-test-python/nba/mapper1.py -mapper ../../mapreduce-test-python/nba/mapper1.py \
-file ../../mapreduce-test-python/nba/reducer1.py -reducer ../../mapreduce-test-python/nba/reducer1.py \
-input /ticket_analysis/input/* -output /nba/output/

# Output the results
/usr/local/hadoop/bin/hdfs dfs -cat /nba/output/part-00000

# Cleanup: Remove the HDFS input and output directories after retrieving the results
/usr/local/hadoop/bin/hdfs dfs -rm -r /nba/input/
/usr/local/hadoop/bin/hdfs dfs -rm -r /nba/output/

# Stop Hadoop services (adjust as needed)
../../stop.sh



#!/bin/bash

# Define paths to mapper and reducer scripts for both phases
MAPPER1_PATH='/nba/mapper1.py'
REDUCER1_PATH='/nba/reducer1.py'
MAPPER2_PATH='/nba/mapper2.py'
REDUCER2_PATH='/nba/to/reducer2.py'

# Define input and output directories
INPUT_DIR='/nba/input'
OUTPUT_DIR_PHASE1='/nba/output/phase1'
OUTPUT_DIR_PHASE2='/nba/output/phase2'


# Define the path to the Hadoop streaming jar
HADOOP_STREAMING_JAR_PATH='/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.1.jar'

# Ensure the output directories do not exist
hdfs dfs -rm -r $OUTPUT_DIR_PHASE1
hdfs dfs -rm -r $OUTPUT_DIR_PHASE1
hdfs dfs -rm -r $INPUT_DIR


# Creating a new input directory in HDFS
/usr/local/hadoop/bin/hdfs dfs -mkdir -p /nba/input/

# Copy the shot_logs.csv from the local filesystem to the input directory in HDFS
/usr/local/hadoop/bin/hdfs dfs -copyFromLocal ../../mapreduce-test-data/shot_logs.csv /nba/input/


# Run Phase 1: Calculate Hit Rates
hadoop jar $HADOOP_STREAMING_JAR_PATH \
  -files $MAPPER1_PATH,$REDUCER1_PATH \
  -mapper `basename $MAPPER1_PATH` \
  -reducer `basename $REDUCER1_PATH` \
  -input $INPUT_DIR/* \
  -output $OUTPUT_DIR_PHASE1

# Run Phase 2: Identify Most Unwanted Defender
hadoop jar $HADOOP_STREAMING_JAR_PATH \
  -files $MAPPER2_PATH,$REDUCER2_PATH \
  -mapper `basename $MAPPER2_PATH` \
  -reducer `basename $REDUCER2_PATH` \
  -input $OUTPUT_DIR_PHASE1/part-* \
  -output $OUTPUT_DIR_PHASE2

# Print the final output
echo "Final Output:"
hdfs dfs -cat $OUTPUT_DIR_PHASE2/part-*





#!/bin/sh

# Start Hadoop services
../../start.sh

# Phase 1: Preparation
# Remove existing output directory and dataset directory (if any)
/usr/local/hadoop/bin/hdfs dfs -rm -r /nba/output1/
/usr/local/hadoop/bin/hdfs dfs -rm -r /nba/input/

# Create new HDFS directory and copy the local dataset to HDFS
/usr/local/hadoop/bin/hdfs dfs -mkdir -p /nba/input/
/usr/local/hadoop/bin/hdfs dfs -copyFromLocal ../../mapreduce-test-data/shot_logs.csv /nba/input/

# Phase 1: Run MapReduce job to calculate hit rates
/usr/local/hadoop/bin/hadoop jar /usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.1.jar \
-file ../../mapreduce-test-python/nba/mapper1.py   -mapper ../../mapreduce-test-python/nba/mapper1.py \
-file ../../mapreduce-test-python/nba/reducer1.py  -reducer ../../mapreduce-test-python/nba/reducer1.py \
-input /nba/to/the/dataset1/* -output /nba/output1/

# Intermediate: View the output of Phase 1 (optional)
/usr/local/hadoop/bin/hdfs dfs -cat /nba/output1/part-00000

# Phase 2: Run MapReduce job to identify the most unwanted defender
# Note: No need to remove/create datasets as we use the output of Phase 1 directly
/usr/local/hadoop/bin/hadoop jar /usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.1.jar \
-file ../../mapreduce-test-python/nba/mapper2.py   -mapper ../../mapreduce-test-python/nba/mapper2.py \
-file ../../mapreduce-test-python/nba/reducer2.py  -reducer ../../mapreduce-test-python/nba/reducer2.py \
-input /nba/output1/part-* -output /nba/output2/

# Final Output: View the results of Phase 2
/usr/local/hadoop/bin/hdfs dfs -cat /nba/output2/part-00000

# Cleanup: Remove temporary HDFS directories
/usr/local/hadoop/bin/hdfs dfs -rm -r /nba/input/
/usr/local/hadoop/bin/hdfs dfs -rm -r /nba/output1/
/usr/local/hadoop/bin/hdfs dfs -rm -r /nba/output2/

# Stop Hadoop services
../../stop.sh


cat ../../mapreduce-test-data/shot_logs.csv | python mapper1.py | sort | python reducer1.py
