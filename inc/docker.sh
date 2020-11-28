# Docker

function get_container_id() {
    local name=$1
    if [ -n "$name" ]; then
        echo $(docker ps | grep $name | awk '{ printf $1 }')
    fi
}

