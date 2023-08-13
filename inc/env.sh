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

function get_hw_temp() {
    paste <(cat /sys/class/thermal/thermal_zone*/type) \
        <(cat /sys/class/thermal/thermal_zone*/temp) | \
        column -s $'\t' -t | sed 's/\(.\)..$/.\1°C/'
}

function uniqueify_path_bash () {
    env_var_name=$1

    old_IFS="$IFS"
    IFS=':'
    read -ra path_array <<< "${!env_var_name}"
    IFS="$old_IFS"

    declare -A unique_paths
    unique_path_array=()

    for path in "${path_array[@]}"; do
        if [ -z "${unique_paths[$path]}" ]; then
            unique_paths[$path]=1
            unique_path_array+=("$path")
        fi
    done

    new_env_var=$(IFS=':'; echo "${unique_path_array[*]}")

    echo "$new_env_var"
}

function uniqueify_path_zsh () {
    env_var_name=$1

    # Save the old IFS value
    old_IFS="$IFS"
    IFS=':'

    # This syntax for reading into an array is bash-specific.
    # In zsh, we'll split the string and read it into an array using a different approach.
    path_array=("${(@s/:/)${(P)env_var_name}}")

    IFS="$old_IFS"

    # Use an associative array to track unique paths.
    typeset -A unique_paths
    unique_path_array=()

    for path in "${path_array[@]}"; do
        if [ -z "${unique_paths[$path]}" ]; then
            unique_paths[$path]=1
            unique_path_array+=("$path")
        fi
    done

    # Join the array back into a colon-separated string.
    new_env_var=$(IFS=':'; echo "${unique_path_array[*]}")

    echo "$new_env_var"
}

function uniqueify_path() {
    if [ -n "$ZSH_VERSION" ]; then
        uniqueify_path_zsh "$@"
    elif [ -n "$BASH_VERSION" ]; then
        uniqueify_path_bash "$@"
    else
        echo "Unsupported shell. Only zsh and bash are supported."
        return 1
    fi
}

function uniqueify_PATH() {
    export PATH=`uniqueify_path PATH`
}

function uniqueify_LD_LIBRARY_PATH() {
    export LD_LIBRARY_PATH=`uniqueify_path LD_LIBRARY_PATH`
}
