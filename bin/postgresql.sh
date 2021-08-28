#!/bin/bash

__dir__=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
postgres=$__dir__/install/bin/postgres

data_root=$__dir__/data
log_path=$__dir__/postgres.log
pid_path=$__dir__/data/postmaster.pid

export PATH=$__dir__/install/bin:$PATH
export LD_LIBRARY_PATH=$__dir__/install/lib:$LD_LIBRARY_PATH

function start() {
    $postgres -D $data_root > $log_path 2>&1 &
    ps aux | grep postgres: | grep -v grep
}

function status() {
    if [ ! -f $pid_path ]; then
        echo "Not running"
    else
        cat $pid_path;
    fi
}

function stop() {
    kill -INT `head -1 $pid_path`
}

function restart() {
    stop
    sleep 1
    start
    status
}

function copy_pg_table_to_db() {
    local $src_table=$1
    local $src_db=$2
    local $dst_db=$3
    if [ -z $src_table ] || [ -z $src_db ] || [ -z $dst_db ]; then
        echo "Usage: copy_table_to_db <src_table> <src_db> <dst_db>"
        return
    fi
    pg_dump -t $src_table $src_db | psql $dst_db
}

if [ $# -eq 0 ]; then
    functions=`grep ^function $0 | cut -d' ' -f 2 | tr -d '()'`
    args=$(echo $functions | sed 's/ /|/g')
    echo "Usage: $0 $args"
    exit
fi

$*
