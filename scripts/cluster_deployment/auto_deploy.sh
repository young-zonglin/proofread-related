#!/bin/bash

set -e
set -x

echo "确定执行`basename $0`吗？这将会自动部署Hadoop和Spark集群"
echo "yes | no"
read flag
if [[ ${flag} != "yes" ]]; then
	echo "什么都没有做，脚本退出"
	exit -1
fi

# 头文件
head_file=head.sh

source head.sh

# 这个脚本只能在主节点执行
if [[ $HOSTNAME != ${MASTER_NODE} ]]; then
	echo "当前主机不是主节点（$MASTER_NODE）"
	echo "这个脚本必须在主节点（$MASTER_NODE）执行"
	exit -2
fi

if [[ ${USER} == root ]]; then
    env_file=/etc/profile
else
    env_file=/home/${USER}/.bashrc
fi

# 在从节点执行的部署脚本
part1_sh=deploy_part1.sh
part2_sh=deploy_part2.sh

# 停止Hadoop和Spark集群
stop-dfs.sh
stop-yarn.sh
${SPARK_PATH}/${SPARK_FOLDER}/sbin/stop-all.sh

# 打包压缩，压缩包会自动覆盖同名压缩包
cd ${JDK_PATH}/
tar czf ${JDK_FOLDER}.tgz ${JDK_FOLDER}
cd ${HADOOP_PATH}/
tar czf ${HADOOP_FOLDER}.tgz ${HADOOP_FOLDER}
cd ${SCALA_PATH}/
tar czf ${SCALA_FOLDER}.tgz ${SCALA_FOLDER}
cd ${SPARK_PATH}/
test -e ${SPARK_FOLDER}/work && rm -fr ${SPARK_FOLDER}/work
tar czf ${SPARK_FOLDER}.tgz ${SPARK_FOLDER}
echo '============打包压缩完毕============'

cd ${cluster_deployment_dir}
for slave_node in ${SLAVE_NODE_LIST}
do
	# 在各个节点上创建目录
	scp ${head_file} ${part1_sh} ${USER}@${slave_node}:~/
	ssh ${USER}@${slave_node} "chmod +x ~/${part1_sh}"
	ssh ${USER}@${slave_node} "bash ~/${part1_sh}"
	echo "============已经在${slave_node}节点上创建了目录============"
	
	# 通过scp发送压缩包
	scp ${JDK_PATH}/${JDK_FOLDER}.tgz ${USER}@${slave_node}:${JDK_PATH}
	scp ${HADOOP_PATH}/${HADOOP_FOLDER}.tgz ${USER}@${slave_node}:${HADOOP_PATH}
	scp ${SCALA_PATH}/${SCALA_FOLDER}.tgz ${USER}@${slave_node}:${SCALA_PATH}
	scp ${SPARK_PATH}/${SPARK_FOLDER}.tgz ${USER}@${slave_node}:${SPARK_PATH}
	echo "============压缩包已经发送到${slave_node}节点============"

	# 发送环境变量配置文件，并source之
	scp ${env_file} ${USER}@${slave_node}:${env_file}
	ssh ${USER}@${slave_node} "source ${env_file}"
	echo "============${slave_node}节点的环境变量配置完毕============"
	
	# 在各个节点上继续配置环境
	scp ${part2_sh} ${USER}@${slave_node}:~/
	ssh ${USER}@${slave_node} "chmod +x ~/${part2_sh}"
	ssh ${USER}@${slave_node} "bash ~/${part2_sh}"
	echo "============${slave_node}节点环境配置完毕============"

	# 删除这些只能在集群部署时使用的脚本
	ssh ${USER}@${slave_node} "test -e ~/${head_file} && rm -f ~/${head_file}"
	ssh ${USER}@${slave_node} "test -e ~/${part1_sh} && rm -f ~/${part1_sh}"
	ssh ${USER}@${slave_node} "test -e ~/${part2_sh} && rm -f ~/${part2_sh}"
done

for node in ${MASTER_NODE} ${SLAVE_NODE_LIST}
do
    # 删除压缩包
    ssh ${USER}@${node} "test -e ${JDK_PATH}/${JDK_FOLDER}.tgz && rm -f ${JDK_PATH}/${JDK_FOLDER}.tgz"
    ssh ${USER}@${node} "test -e ${HADOOP_PATH}/${HADOOP_FOLDER}.tgz && rm -f ${HADOOP_PATH}/${HADOOP_FOLDER}.tgz"
    ssh ${USER}@${node} "test -e ${SCALA_PATH}/${SCALA_FOLDER}.tgz && rm -f ${SCALA_PATH}/${SCALA_FOLDER}.tgz"
    ssh ${USER}@${node} "test -e ${SPARK_PATH}/${SPARK_FOLDER}.tgz && rm -f ${SPARK_PATH}/${SPARK_FOLDER}.tgz"

    # 改变文件夹的所属用户
    ssh ${USER}@${node} "chown -R ${USER}:${USER} ${HADOOP_PATH}/${HADOOP_FOLDER}"
    ssh ${USER}@${node} "chown -R ${USER}:${USER} ${SPARK_PATH}/${SPARK_FOLDER}"

     # 删除hadoop和spark的log目录下的日志文件
    ssh ${USER}@${node} "test -d ${HADOOP_PATH}/${HADOOP_FOLDER} && rm -fr ${HADOOP_PATH}/${HADOOP_FOLDER}/logs/*"
    ssh ${USER}@${node} "test -d ${SPARK_PATH}/${SPARK_FOLDER} && rm -fr ${SPARK_PATH}/${SPARK_FOLDER}/logs/*"

    # 创建${hadoop.tmp.dir}目录
    ssh ${USER}@${node} "mkdir -p ${HADOOP_TMP_DIR}"
    ssh ${USER}@${node} "chmod 777 ${HADOOP_TMP_DIR}"
    ssh ${USER}@${node} "test -d ${HADOOP_TMP_DIR} && rm -fr ${HADOOP_TMP_DIR}/*"
done

# 格式化Hadoop集群
hdfs namenode -format

# 开启Hadoop和Spark集群
start-dfs.sh
start-yarn.sh
${SPARK_PATH}/${SPARK_FOLDER}/sbin/start-all.sh

# 测试Hadoop和Spark集群
bash hadoop_pi.sh
bash spark_pi.sh

