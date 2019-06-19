#!/bin/bash

set -e
set -x

source head.sh

# 如果不是目录，就删除
if [[ ! -d ${JDK_PATH} ]]; then
	test -e ${JDK_PATH} && rm -f ${JDK_PATH}
fi
if [[ ! -d ${HADOOP_PATH} ]]; then
	test -e ${HADOOP_PATH} && rm -f ${HADOOP_PATH}
fi
if [[ ! -d ${SCALA_PATH} ]]; then
	test -e ${SCALA_PATH} && rm -f ${SCALA_PATH}
fi
if [[ ! -d ${SPARK_PATH} ]]; then
	test -e ${SPARK_PATH} && rm -f ${SPARK_PATH}
fi

# 如果目录不存在，就创建目录
mkdir -p ${JDK_PATH}
mkdir -p ${HADOOP_PATH}
mkdir -p ${SCALA_PATH}
mkdir -p ${SPARK_PATH}

