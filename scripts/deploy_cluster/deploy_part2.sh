#!/bin/bash

set -e
set -x

source head.sh

# 这个脚本不能在主节点执行
if [[ $HOSTNAME = ${MASTER_NODE} ]]; then
	echo "当前主机是主节点（$MASTER_NODE）"
	echo "这个脚本不能在主节点（$MASTER_NODE）执行"
	exit -1
fi

# 先判断是不是已经有压缩包了
if [[ ! -e ${JDK_PATH}/${JDK_FOLDER}.tgz || ! -e ${HADOOP_PATH}/${HADOOP_FOLDER}.tgz || ! -e ${SCALA_PATH}/${SCALA_FOLDER}.tgz ]] || [[ ! -e ${SPARK_PATH}/${SPARK_FOLDER}.tgz ]]; then
	echo "压缩包不存在"
	exit -2
fi

# 删除同名的jdk、scala、hadoop、spark文件夹
test -e ${JDK_PATH}/${JDK_FOLDER} && rm -fr ${JDK_PATH}/${JDK_FOLDER}
test -e ${HADOOP_PATH}/${HADOOP_FOLDER} && rm -fr ${HADOOP_PATH}/${HADOOP_FOLDER}
test -e ${SCALA_PATH}/${SCALA_FOLDER} && rm -fr ${SCALA_PATH}/${SCALA_FOLDER}
test -e ${SPARK_PATH}/${SPARK_FOLDER} && rm -fr ${SPARK_PATH}/${SPARK_FOLDER}

# 解压
tar xzf ${JDK_PATH}/${JDK_FOLDER}.tgz -C ${JDK_PATH}
tar xzf ${HADOOP_PATH}/${HADOOP_FOLDER}.tgz -C ${HADOOP_PATH}
tar xzf ${SCALA_PATH}/${SCALA_FOLDER}.tgz -C ${SCALA_PATH}
tar xzf ${SPARK_PATH}/${SPARK_FOLDER}.tgz -C ${SPARK_PATH}

