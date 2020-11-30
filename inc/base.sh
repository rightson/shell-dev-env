# Common


if [ "$0" = "${BASH_SOURCE[0]}" ]; then
    export ENV_SHELL_PATH=$(which `ps -p$PPID | tail -1 | awk '{print $NF}' | xargs basename | tr -cd '[:alnum:]'`)
else
    export ENV_SHELL_PATH=$(which $0)
fi

export SHELL_NAME=`basename $ENV_SHELL_PATH`

if [ "$SHELL_NAME" = bash ]; then
    export ENV_ROOT=$(cd `dirname ${BASH_SOURCE[0]}`/.. && pwd)
elif [ "$SHELL_NAME" = zsh ]; then
    export ENV_ROOT=$(cd ${0:a:h}/.. && pwd)
fi

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

