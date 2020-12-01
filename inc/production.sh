function git_checkout_latest_tag() {
    git fetch --tags 2> /dev/null
    git tag | tail -1
    git tag | tail -1 | xargs git checkout
}

function restart_pm2_by_range() {
    local start=$1
    local end=$2
    local interval=$3
    if [ -z "$start" ]; then
        local start=0
    fi
    if [ -z "$end" ]; then
        local end=7
    fi
    if [ -z "$interval" ]; then
        local interval=5
    fi
    for id in `seq $start $end`; do
        cmd="pm2 restart $id";
        echo "$cmd"
        $cmd
        sleep $interval;
    done
}


