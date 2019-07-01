#!/bin/bash

process_name="StreamingProofread"  # 进程名
log_dir="~/streaming_log/"  # 日志目录
log_file="streaming_app_restart.log"  # 日志文件
pid=0

# 计算指定进程的数目
get_process_num()
{
	num=`ps -ef | grep ${process_name} | grep -v grep | wc -l`
	return ${num}
}

# 获取指定进程ID
get_process_ID()
{
	pid=`ps -ef | grep ${process_name} | grep -v grep | awk '{print $2}'`
}

get_process_num
number=$?
if [[ ${number} -eq 0 ]]  # 判断进程是否存在
then
	# 重启进程的命令，请相应修改
	cd ~/proofread_swjtu/proofread-related/scripts/proofread_script/; bash streaming_proofread.sh
	get_process_ID  # 获取新进程号
	test ! -d ${log_dir} && test -e ${log_dir} && rm -f ${log_dir}
	test ! -e ${log_dir} && mkdir -p ${log_dir}
	echo ${pid}, `date` >> ${log_dir}/${log_file}  # 将新进程号和重启时间记录
fi

