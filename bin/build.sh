#!/bin/sh
d=$(cd $(dirname $0)/ && pwd)

log_dir="$d/log"
mkdir -p $log_dir
log_file="$log_dir/docker.build.log"

echo "`date +'%Y/%m/%d %T'` - Start" > $log_file
stdbuf -oL docker-compose build $* | tee -a $log_file
echo "`date +'%Y/%m/%d %T'` - End" >> $log_file
