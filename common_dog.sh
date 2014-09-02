#!/bin/sh

log() {
	msg=$1
	date_str=`date +"%Y-%m-%d %H:%M:%S"`
	echo "[$date_str] $msg"
}

curdir=`dirname $0`
config_file=dog.config
app_log_dir=logs

config_file_full=$curdir/$config_file
app_log_dir_full=$curdir/$app_log_dir


log "begin to monitor"
cat $config_file_full | while read line 
do	
	name=`echo "$line" | awk -F '###' '{print $1}'`
	process=`echo "$line" | awk -F '###' '{print $2}'`
	if [ -z "$name" ] || [ -z "$process" ] ; then
		echo "$name config error"
		continue
	fi
	count=`ps -ef | grep "$process" | grep -v grep |  grep $USER | wc -l`
	log "$name: $count"
	if [ $count -gt 0 ]; then
		log "$name is alived"
	else
		$process &
		log "$name is dead, restart"
	fi
done 
log "end to monitor"


