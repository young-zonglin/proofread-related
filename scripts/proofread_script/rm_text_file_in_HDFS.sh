#!/bin/bash

source ../cluster_deployment/head.sh

HADOOP_HOME=${HADOOP_PATH}/${HADOOP_FOLDER}
filename=$1

${HADOOP_HOME}/bin/hdfs dfs -rm ${monitor_dir}/${filename}

