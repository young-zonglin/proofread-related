#!/usr/bin/env bash

source func.sh

shell_scripts_dir=~/proofread_swjtu/proofread-related/scripts/proofread_script/
process_name="StreamingProofread"

get_process_num ${process_name}
number=$?
if [[ ${number} -ne 0 ]]; then
	echo `get_process_ID ${process_name}` | xargs kill -9
fi

cd ${shell_scripts_dir}
bash streaming_proofread.sh

echo 'restart streaming proofreading service at '`date` >> ~/proofread_swjtu/proofreading_restart.log
