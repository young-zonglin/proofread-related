#!/usr/bin/env bash

# 在这里修改用户
USER=hadoop

# 相关软件的目录和文件夹名
JDK_PATH=/usr/local/jdk
JDK_FOLDER=jdk1.7.0_15
HADOOP_PATH=/usr/local/hadoop
HADOOP_FOLDER=hadoop-2.6.0
SCALA_PATH=/usr/local/scala
SCALA_FOLDER=scala-2.11.8
SPARK_PATH=/usr/local/spark
SPARK_FOLDER=spark-2.1.0-bin-hadoop2.6

HADOOP_TMP_DIR=/var/hadoop

# 修改集群节点
MASTER_NODE=ccit20
SLAVE_NODE_LIST="ccit21 ccit22"
