# Common

export ENV_ROOT=$(cd `dirname ${BASH_SOURCE[0]}`/.. && pwd)

export EXIT_SUCCESS=0
export EXIT_FAILURE=-1

function die() {
    echo $@;
    exit $EXIT_FAILURE;
}

function run() {
    echo $@;
    eval $@;
    return $?
}

