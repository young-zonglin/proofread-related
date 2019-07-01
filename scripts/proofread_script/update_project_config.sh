#!/bin/bash

source ../cluster_deployment/head.sh

# 这个脚本只能在主节点执行
if [[ $HOSTNAME != ${MASTER_NODE} ]]; then
	echo "当前主机不是主节点（$MASTER_NODE）"
	echo "这个脚本必须在主节点（$MASTER_NODE）执行"
	exit -1
fi

proofread_config=~/proofread_swjtu/proofread_config/
for slave_node in ${SLAVE_NODE_LIST}
do
    ssh ${USER}@${slave_node} "mkdir -p ${proofread_config}"
    scp ${proofread_config}/* ${USER}@${slave_node}:${proofread_config}/
done
