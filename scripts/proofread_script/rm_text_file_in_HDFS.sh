#!/bin/bash

HADOOP_HOME=$1
filename=$2
monitorDir=$3

${HADOOP_HOME}/bin/hdfs dfs -rm ${monitorDir}${filename}

