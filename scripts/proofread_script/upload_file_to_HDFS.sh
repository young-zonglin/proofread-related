#!/bin/bash

source ../cluster_deployment/head.sh

path=$1
filename=$2

HADOOP_HOME=${HADOOP_PATH}/${HADOOP_FOLDER}

${HADOOP_HOME}/bin/hdfs dfs -put ${path}/${filename} ${temp_dir}/${filename}
${HADOOP_HOME}/bin/hdfs dfs -mv ${temp_dir}/${filename} ${monitor_dir}/${filename}

test -e ${path}/${filename} && rm -f ${path}/${filename}
