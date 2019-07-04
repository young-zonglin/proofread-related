#!/usr/bin/env bash

# 计算指定进程的数目
# usage: get_process_num <process_name>
get_process_num() {
    process_name=$1
	num=`ps -ef | grep ${process_name} | grep -v grep | wc -l`
	return ${num}  # 只能返回数字
}

# 获取指定进程的ID
# usage: get_process_ID <process_name>
get_process_ID()
{
    process_name=$1
	pids=`ps -ef | grep ${process_name} | grep -v grep | awk '{print $2}'`
	echo ${pids}
}

