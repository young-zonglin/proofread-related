#!/bin/bash

HADOOP_HOME=$1
path=$2
filename=$3
monitorDir=$4
tempDir=$5

${HADOOP_HOME}/bin/hdfs dfs -put ${path}${filename} ${tempDir}${filename}
${HADOOP_HOME}/bin/hdfs dfs -mv ${tempDir}${filename} ${monitorDir}${filename}

test -e ${path}${filename} && rm -f ${path}${filename}
