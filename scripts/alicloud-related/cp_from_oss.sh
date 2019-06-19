#!/bin/bash

DATA_COPY_FROM_OSS="/root/data_copy_from_oss"

test ! -d ${DATA_COPY_FROM_OSS} && test -e ${DATA_COPY_FROM_OSS} && rm -f ${DATA_COPY_FROM_OSS}
test ! -e ${DATA_COPY_FROM_OSS} && mkdir -p ${DATA_COPY_FROM_OSS}
/root/ossutil64 cp oss://ccit-proofread-bucket/api-jar-upload/ProofreadAPI.jar ${DATA_COPY_FROM_OSS}/ProofreadAPI.jar 
echo "ProofreadAPI.jar从OSS下载完毕"
echo "==============================="                                                                                      
/root/ossutil64 cp oss://ccit-proofread-bucket/web-war-upload/Proofread.war ${DATA_COPY_FROM_OSS}/Proofread.war
echo "Proofread.war从OSS下载完毕"
echo "===============================" 

