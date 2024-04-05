In CISC 5950, we have learned the following topics,
1. Set up a 3-node cluster with Hadoop Distributed File System and run examples.
2. On top of HDFS, set up the cluster with MapReduce programming framework.
3. Run examples of MapReduce programs.
4. Scheuling on the Cloud.
In this project, we are going to design our own Hadoop MapReduce-based program to analyze
the data. The project consist of two parts.
NY Parking Violations
The NYC Department of Finance collects data on every parking ticket issued in NYC ( 10M
per year!). This data is made publicly available to aid in ticket resolution and to guide policymakers.


The above figure shows several records, where each row represents a parking ticket and the
columns are the details of the tickets.
To start the project, you have to,
1. Start the 3-node cluster
2. Set up the HDFS
3. Store the data in HDFS
4. Set up the MapReduce framework along with the scheduler for resource management.

attached image is a preview of the dataset

By analyzing the data, we need to answer the following,
• When are tickets most likely to be issued?
ChatGPT
You're embarking on a project that involves using Hadoop and its ecosystem to analyze parking violation data from NYC. That's quite a task! The dataset preview in the image you've provided gives us an idea of the types of data we'll be dealing with: plate ID, registration state, plate type, issue date, violation code, vehicle body type, vehicle make, issuing agency, and street code.

To determine when tickets are most likely to be issued, we'll want to focus on the "Issue Date" column. Here’s how you can go about it:

Start your 3-node Hadoop cluster: Ensure each node is properly configured and communicating with the others.

Set up HDFS (Hadoop Distributed File System): This will be used to store your parking violation data in a distributed manner. You need to format the file system and start the HDFS services on all nodes.

Store the data in HDFS: You'll want to import your dataset into HDFS. You can do this using commands like hdfs dfs -put localfile /hadoopfile.

Set up the MapReduce framework and scheduler: Configure your MapReduce environment and the scheduler (like YARN), which will manage resources and job scheduling.

Design a MapReduce program: You'll write a Mapper that parses each record and outputs the issue date, and a Reducer that counts the number of tickets per date.

For example:

The Mapper reads each line, extracts the issue date, and writes it out with a count of 1.
The Reducer sums all counts for each date.
Run your MapReduce job: Execute your MapReduce program on the cluster to process the data.

Analysis of the results: Once the job is complete, you can examine the output to see which dates have the highest counts of tickets issued.

Remember, the MapReduce job will need to handle parsing of the date and time, and consider the format the dates are in (looks like mm/dd/yyyy in your screenshot). You might want to normalize this data if it’s not consistent throughout the dataset.

Also, this approach can be further extended if you're interested in the time of day or if you want to correlate this with other factors such as violation types or locations.

Once your MapReduce program is successfully analyzing the data, you can begin to draw conclusions on trends such as the times of year, week, or month when tickets are most often issued. Good luck with your project!

User
write the python code for the mapReduce to answer the question
ChatGPT
Certainly! To analyze the data to find out when tickets are most likely to be issued, we can write a MapReduce program using Python. We'll use the Hadoop Streaming utility to run the Python script. Here's a simple example of how the Mapper and Reducer scripts might look:

Mapper.py

python
Copy code
#!/usr/bin/env python
"""mapper.py"""

import sys

# The input comes from standard input (line by line)
for line in sys.stdin:
    line = line.strip()  # remove leading and trailing whitespace
    fields = line.split()  # split the line into fields
    
    # Check if we have the correct number of fields
    if len(fields) == 10:
        # Extract the issue date
        issue_date = fields[4]
        print(f'{issue_date}\t1')
Reducer.py

python
Copy code
#!/usr/bin/env python
"""reducer.py"""

import sys
from collections import defaultdict

current_date = None
current_count = 0
date_count = defaultdict(int)

# The input comes from standard input (line by line)
for line in sys.stdin:
    line = line.strip()  # remove leading and trailing whitespace
    date, count = line.split('\t', 1)  # split the line into key/value

    try:
        count = int(count)  # convert count (currently a string) to int
    except ValueError:
        continue

    if current_date == date:
        current_count += count
    else:
        if current_date:
            # write result to standard output
            print(f'{current_date}\t{current_count}')
        current_date = date
        current_count = count

# output the last date if needed
if current_date == date:
    print(f'{current_date}\t{current_count}')
To run these scripts on a Hadoop cluster, you'll need to have Hadoop installed and the HDFS set up. Then you can use the Hadoop Streaming API to run the Python code.

Here's how you would run the MapReduce job using the Hadoop Streaming API:

sh
Copy code
hadoop jar /path/to/hadoop-streaming.jar \
-file /path/to/mapper.py    -mapper /path/to/mapper.py \
-file /path/to/reducer.py   -reducer /path/to/reducer.py \
-input /input/dataset/path/on/hdfs   -output /output/path/on/hdfs
Make sure to replace /path/to/ with the actual paths to your mapper and reducer scripts, and update the /input/dataset/path/on/hdfs and /output/path/on/hdfs with the correct HDFS paths.

Also, don't forget to make your Python scripts executable by running chmod +x mapper.py and chmod +x reducer.py.

This code assumes that the input is tab-delimited and that the issue date is the fifth field in the dataset (as in the screenshot provided). Adjust the field index in the mapper.py if your data is structured differently.

User
What are the most common years and types of cars to be ticketed?
ChatGPT
To answer this question, you would need to analyze both the "Issue Date" and "Vehicle Make" columns from your dataset to find the most common years and types of cars that are ticketed. Here’s how you can set up your MapReduce program to get this information:

Mapper:

The Mapper script will read each line, extract the year from the "Issue Date" and the "Vehicle Make," and output them with a count of 1. In your dataset, it appears that the "Issue Date" is the fifth field and the "Vehicle Make" is the seventh field.

mapper.py

python
Copy code
#!/usr/bin/env python
"""mapper.py"""

import sys

# The input comes from standard input (line by line)
for line in sys.stdin:
    line = line.strip()  # Remove leading and trailing whitespace
    fields = line.split()  # Split the line into fields
    
    # Check if we have the correct number of fields
    if len(fields) >= 8:
        issue_date = fields[4]
        vehicle_make = fields[7]
        year = issue_date.split('/')[-1]  # Assuming the date format is mm/dd/yyyy

        # Output the year and vehicle make
        print(f'{year}\t{vehicle_make}\t1')
Reducer:

The Reducer script will sum all counts for each year and vehicle make combination.

reducer.py

python
Copy code
#!/usr/bin/env python
"""reducer.py"""

import sys
from collections import defaultdict

year_make_count = defaultdict(int)

# The input comes from standard input (line by line)
for line in sys.stdin:
    line = line.strip()  # Remove leading and trailing whitespace
    year_make, count = line.split('\t', 2)  # Split the line into key and value

    try:
        count = int(count)  # Convert count (currently a string) to int
    except ValueError:
        continue

    year_make_count[year_make] += count

# Output the count for each year and make
for year_make, count in year_make_count.items():
    year, make = year_make.split('\t')
    print(f'{year}\t{make}\t{count}')
The above Reducer assumes you're not concerned with sorting or finding the most common years and types directly within the MapReduce job. Usually, this sort of "top N" problem is handled by a secondary process, because MapReduce's sorting capabilities are global, not per-key.

After the MapReduce job is completed, you can sort the results outside of MapReduce to find the most common combinations of year and car types that receive tickets.

Run the MapReduce job using the Hadoop Streaming API similarly to the previous example, with the updated mapper and reducer paths.

This setup assumes that your input data is correctly formatted and that the fields are consistently in the correct order. If your data is comma-separated or has a different structure, you'll need to adjust the parsing logic in the mapper script accordingly.

User
Where are tickets most commonly issued?
ChatGPT
To determine where tickets are most commonly issued using your Hadoop MapReduce setup, you would need to analyze the "Street Code" column from your dataset, as that seems to be the column indicating the location of the parking violation.

Here’s a basic outline of how the Mapper and Reducer scripts would look for this task:

Mapper:

The Mapper script would extract the "Street Code" field from each record. Based on the screenshot, the "Street Code" is the last column in the dataset.

mapper.py

python
Copy code
#!/usr/bin/env python
"""mapper.py"""

import sys

# The input comes from standard input (line by line)
for line in sys.stdin:
    line = line.strip()  # Remove leading and trailing whitespace
    fields = line.split()  # Split the line into fields

    # Assuming the street code is the last field
    # Check if we have a non-empty line and enough fields
    if fields and len(fields) >= 9:
        street_code = fields[-1]  # Get the last field as street code
        
        # Output the street code with a count of 1
        print(f'{street_code}\t1')
Reducer:

The Reducer script will sum all counts for each street code, thus determining how many tickets were issued for each street code.

reducer.py

python
Copy code
#!/usr/bin/env python
"""reducer.py"""

import sys

current_street_code = None
current_count = 0

# The input comes from standard input (line by line)
for line in sys.stdin:
    line = line.strip()  # Remove leading and trailing whitespace
    street_code, count = line.split('\t', 1)  # Split the line into key/value

    try:
        count = int(count)  # Convert count (currently a string) to int
    except ValueError:
        continue

    # If the current street code is the same as the last one we processed
    if current_street_code == street_code:
        current_count += count
    else:
        if current_street_code:
            # Write result to standard output
            print(f'{current_street_code}\t{current_count}')
        current_street_code = street_code
        current_count = count

# Output the last street code if needed
if current_street_code == street_code:
    print(f'{current_street_code}\t{current_count}')
You would run this MapReduce job on your Hadoop cluster in a similar way as previously described. Remember to replace the paths with the actual paths to your scripts and input/output directories.

Once the MapReduce job completes, you would have a list of street codes and their associated counts. The highest counts would indicate where tickets are most commonly issued. You might need to join this output with a dataset that maps street codes to actual street names or locations for more meaningful insights, as street codes alone may not be informative for human analysis.

User
Which color of the vehicle is most likely to get a ticket?
ChatGPT
To determine which color of the vehicle is most likely to get a ticket from the dataset, you would write a MapReduce program where the Mapper extracts the vehicle color and the Reducer sums the occurrences of each color. However, from the screenshot you've provided, it appears that the vehicle color is not a part of the dataset. In a typical parking ticket dataset, you might expect a column for vehicle color—if that information is available in a different column or in a fuller version of your dataset, you could adapt the code accordingly.

If you had the color information, your Mapper would look similar to the following, assuming that vehicle color is the hypothetical eighth column in the dataset:

Mapper.py

python
Copy code
#!/usr/bin/env python
"""mapper.py"""

import sys

for line in sys.stdin:
    line = line.strip()
    fields = line.split()
    if len(fields) > 7:  # Assuming color is the eighth field
        vehicle_color = fields[7]
        print(f'{vehicle_color}\t1')
The Reducer would collect these and sum them:

Reducer.py

python
Copy code
#!/usr/bin/env python
"""reducer.py"""

import sys

current_color = None
current_count = 0

for line in sys.stdin:
    line = line.strip()
    color, count = line.split('\t')

    try:
        count = int(count)
    except ValueError:
        continue

    if current_color == color:
        current_count += count
    else:
        if current_color:
            print(f'{current_color}\t{current_count}')
        current_color = color
        current_count = count

if current_color == color:  # Output the last color if needed
    print(f'{current_color}\t{current_count}')
These scripts assume that each line of the input data is whitespace-delimited and that the eighth field contains the color information for the vehicle. If your dataset uses a different delimiter, you would need to modify the split() function to use the correct delimiter (e.g., split(',') for comma-separated values).

Once you have the color data in the correct column, you can run these scripts as part of a Hadoop Streaming job to get the count of tickets by vehicle color. The most frequently occurring color in the output will be the color of the vehicle most likely to get a ticket.

Again, please adjust the field index as per your actual dataset, and if the vehicle color data is not available, you would need to acquire a dataset that includes this information to perform the analysis.