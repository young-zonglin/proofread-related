#!/bin/bash

source func.sh

process_name="StreamingProofread"  # 进程名
log_dir="~/streaming_log/"  # 日志目录
log_file="streaming_app_restart.log"  # 日志文件

get_process_num ${process_name}
number=$?
# 判断进程是否存在
if [[ ${number} -eq 0 ]]; then
	# 重启进程的命令，请相应修改
	cd ~/proofread_swjtu/proofread-related/scripts/proofread_script/; bash streaming_proofread.sh
	test ! -d ${log_dir} && test -e ${log_dir} && rm -f ${log_dir}
	test ! -e ${log_dir} && mkdir -p ${log_dir}
	# 获取新进程号
	echo `get_process_ID ${process_name}`, `date` >> ${log_dir}/${log_file}  # 记录新进程号和重启时间
fi

