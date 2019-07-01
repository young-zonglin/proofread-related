#!/bin/bash

source ../cluster_deployment/head.sh

api_jar=${HOME}/ProofreadAPI.jar
HADOOP_HOME=${HADOOP_PATH}/${HADOOP_FOLDER}
SPARK_HOME=${SPARK_PATH}/${SPARK_FOLDER}
batch_duration=10

${HADOOP_HOME}/bin/hdfs dfs -mkdir -p ${monitor_dir}
${HADOOP_HOME}/bin/hdfs dfs -mkdir -p ${temp_dir}

nohup ${SPARK_HOME}/bin/spark-submit \
    --master spark://${MASTER_NODE}:8070 \
    --conf spark.memory.fraction=0.2 \
    --conf spark.serializer=org.apache.spark.serializer.KryoSerializer \
    --conf spark.eventLog.enabled=false \
    --total-executor-cores 40 \
    --executor-cores 20 \
    --executor-memory 20g \
    --driver-memory 2g \
    --class com.swjtu.ccit.Service.parallel.StreamingProofread \
    ${api_jar} ${monitor_dir} ${batch_duration} 1>out.file 2>err.file &

#--driver-java-options -XX:+UseConcMarkSweepGC \
#--conf spark.executor.extraJavaOptions=-XX:+UseConcMarkSweepGC \

#--conf spark.kryo.registrationRequired=true \
#--conf spark.speculation=true \
