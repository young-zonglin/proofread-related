#!/usr/bin/env bash

source func.sh
source ../cluster_deployment/head.sh

TOMCAT_HOME=${software_dir}/tomcat/tomcat-7.0.75/
process_name=tomcat

get_process_num ${process_name}
number=$?
if [[ ${number} -ne 0 ]]; then
    ${TOMCAT_HOME}/bin/shutdown.sh
	echo `get_process_ID ${process_name}` | xargs kill -9
fi

${TOMCAT_HOME}/bin/startup.sh

