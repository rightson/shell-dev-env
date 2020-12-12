# Common

if [ -z "${ENV_ROOT}" ]; then
    if [ -n "${BASH_SOURCE[0]}" ]; then
        export ENV_ROOT=$(cd `dirname ${BASH_SOURCE[0]}`/.. && pwd)
    else
        export ENV_ROOT=$(cd ${0:a:h}/.. && pwd)
    fi
fi

if [ -n "$shell" ]; then
    export SHELL_PATH=$shell
else
    SHELL_NAME=`ps -p$$ | tail -1 | awk '{print $NF}' | tr -cd '[:alnum:]/' | xargs basename`
    export SHELL_PATH=$(which $SHELL_NAME)
fi

export SHELL_NAME=`basename $SHELL_PATH`

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

