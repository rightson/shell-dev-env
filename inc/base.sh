# Common

if [ -z "${ENV_ROOT}" ]; then
    if [ -n "${BASH_SOURCE[0]}" ]; then
        export ENV_ROOT=$(cd `dirname ${BASH_SOURCE[0]}`/.. && pwd)
    else
        export ENV_ROOT=$(cd ${0:a:h}/.. && pwd)
    fi
fi

if [ -n "$version" ] && [ -n "$shell" ]; then
    export SHELL_PATH=`which csh`
    if [ ! -f $SHELL_PATH ]; then
        export SHELL_PATH=`which tcsh`
    fi
elif [ -n "$BASH" ]; then
    export SHELL_PATH=`which bash`
elif [ -n "$ZSH_NAME" ]; then
    export SHELL_PATH=`which zsh`
fi

export SHELL_NAME=`basename ${SHELL_PATH:-bash}`

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

