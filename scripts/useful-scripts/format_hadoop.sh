#!/bin/bash

set -e
set -x

scriptName=$0
echo "确定执行${scriptName##*/}吗？这将会格式化Hadoop集群"
echo "yes | no"
read flag
if [[ ${flag} != "yes" ]]; then
	echo "什么都没有做，脚本退出"
	exit -1
fi

source ../cluster_deployment/head.sh

# 这个脚本只能在主节点执行
if [[ $HOSTNAME != ${MASTER_NODE} ]]; then
	echo "当前主机不是主节点（$MASTER_NODE）"
	echo "这个脚本必须在主节点（$MASTER_NODE）执行"
	exit -2
fi

stop-all.sh
for node in ${MASTER_NODE} ${SLAVE_NODE_LIST}
do
	ssh ${USER}@${node} "test -d ${HADOOP_TMP_DIR} && rm -fr ${HADOOP_TMP_DIR}/*"
	echo "===========${node}节点格式化完毕==========="
done
hadoop namenode -format
start-all.sh
