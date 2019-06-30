#!/bin/bash

echo "确定执行`basename $0`吗？这将会更新集群各个节点的配置信息"
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

SPARK_CONF_PATH=${SPARK_PATH}/${SPARK_FOLDER}/conf
HADOOP_CONF_PATH=${HADOOP_PATH}/${HADOOP_FOLDER}/etc/hadoop

SPARK_CONF_FILES="spark-defaults.conf spark-env.sh slaves log4j.properties"
HADOOP_CONF_FILES="hadoop-env.sh yarn-env.sh slaves core-site.xml hdfs-site.xml yarn-site.xml mapred-site.xml"

stop-dfs.sh
stop-yarn.sh
${SPARK_PATH}/${SPARK_FOLDER}/sbin/stop-all.sh

for slave_node in ${SLAVE_NODE_LIST}
do
    scp ${env_file} ${USER}@${slave_node}:${env_file}
	ssh ${USER}@${slave_node} "source ${env_file}"

	for spark_conf_file in ${SPARK_CONF_FILES}
	do
		scp ${SPARK_CONF_PATH}/${spark_conf_file} ${USER}@${slave_node}:${SPARK_CONF_PATH}
	done

	for hadoop_conf_file in ${HADOOP_CONF_FILES}
	do
		scp ${HADOOP_CONF_PATH}/${hadoop_conf_file} ${USER}@${slave_node}:${HADOOP_CONF_PATH}
	done

	echo "===========${slave_node}节点集群配置文件更新完毕==========="
done

