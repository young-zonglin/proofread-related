#!/usr/bin/env bash

source head.sh

yarn jar \
    ${HADOOP_PATH}/${HADOOP_FOLDER}/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.6.0.jar \
    pi 10 10
