# Env

function registerPath() {
    if [ -z $1 ]; then
        echo "Error: failed to register PATH: path not specified";
        return $EXIT_FAILURE;
    fi
    if [ ! -d $1 ]; then
        echo "Error: failed to register $1 to PATH: path $1 not existed";
        return $EXIT_FAILURE;
    fi
    export PATH=$1:$PATH
}

function registerLibrary() {
    if [ -z $1 ]; then
        echo "Error: failed to register LD_LIBRARY_PATH: path not specified";
        return $EXIT_FAILURE;
    fi
    if [ ! -d $1 ]; then
        echo "Error: failed to register $1 to LD_LIBRARY_PATH: path $1 not existed";
        return $EXIT_FAILURE;
    fi
    export LD_LIBRARY_PATH=$1:$LD_LIBRARY_PATH
}

function registerPathAndLibrary {
    registerPath $1/bin
    if [ $? -ne $EXIT_SUCCESS ]; then
        return $EXIT_FAILURE;
    fi
    registerLibrary $1/lib
    if [ $? -ne $EXIT_SUCCESS ]; then
        return $EXIT_FAILURE;
    fi
}

function set_go_path() {
    if [ ! -z $1 ]; then
        export GOPATH=`cd $1 && pwd`
        export PATH=$GOPATH/bin:$PATH
    fi
    echo $GOPATH
}

function env_self_update() {
    cd $ENV_ROOT && git pull && cd -
}
