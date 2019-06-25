#!/usr/bin/env bash

# 在这里修改用户
USER=hadoop
software_dir=${HOME}/software/

# 相关软件的目录和文件夹名
JDK_PATH=${software_dir}/jdk
JDK_FOLDER=jdk1.7.0_15
HADOOP_PATH=${software_dir}/hadoop
HADOOP_FOLDER=hadoop-2.6.0
SCALA_PATH=${software_dir}/scala
SCALA_FOLDER=scala-2.11.8
SPARK_PATH=${software_dir}/spark
SPARK_FOLDER=spark-2.1.0-bin-hadoop2.6

HADOOP_TMP_DIR=/var/hadoop

# 修改集群节点
MASTER_NODE=amaxsrv06
SLAVE_NODE_LIST="amaxsrv03"
