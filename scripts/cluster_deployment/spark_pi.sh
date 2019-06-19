#!/bin/bash

source head.sh

spark-submit \
  --master spark://${MASTER_NODE}:8070 \
  --class org.apache.spark.examples.SparkPi \
  ${SPARK_PATH}/${SPARK_FOLDER}/examples/jars/spark-examples_2.11-2.1.0.jar \
  10
