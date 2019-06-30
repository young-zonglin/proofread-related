#!/bin/bash

PROOFREAD_BANK_PATH=~/proofread_swjtu/
PROOFREAD_BANK_FOLDER=proofread_data

echo "确定执行`basename $0`吗？这将会更新集群各从节点的词库和规则库"
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

for slave_node in ${SLAVE_NODE_LIST}
do
	ssh ${USER}@${slave_node} "test ! -d ${PROOFREAD_BANK_PATH} && test -e ${PROOFREAD_BANK_PATH} && rm -f ${PROOFREAD_BANK_PATH}"
	ssh ${USER}@${slave_node} "mkdir -p ${PROOFREAD_BANK_PATH}"
	ssh ${USER}@${slave_node} "test -e ${PROOFREAD_BANK_PATH}/${PROOFREAD_BANK_FOLDER} && rm -fr ${PROOFREAD_BANK_PATH}/${PROOFREAD_BANK_FOLDER}"
	scp -r ${PROOFREAD_BANK_PATH}/${PROOFREAD_BANK_FOLDER} ${USER}@${slave_node}:${PROOFREAD_BANK_PATH}
	echo "===========${slave_node}节点词库和规则库更新完毕==========="
done

