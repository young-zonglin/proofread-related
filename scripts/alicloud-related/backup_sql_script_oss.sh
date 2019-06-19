#!/bin/bash

PARAM_NUM=1

if [[ $# -ne ${PARAM_NUM} ]]; then
  echo "Error: parameter num is not ${PARAM_NUM}"
  echo "USAGE: `basename $0` <time_suffix>"
  exit -1
fi

TIME_SUFFIX=$1
/root/ossutil64 cp oss://ccit-proofread-bucket/proofread-db-backup/proofread.sql oss://ccit-proofread-bucket/proofread-db-backup/proofread.sql.${TIME_SUFFIX}
echo "proofread.sql => proofread.sql.${TIME_SUFFIX}"
echo "===============================" 

