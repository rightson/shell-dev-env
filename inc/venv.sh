# Virtualenv

if [ -z "$MY_DEV_ROOT" ]; then
    export MY_DEV_ROOT=$HOME/workspace
fi

if [ -z "$MY_VIRTUALENV_ROOT" ]; then
    export MY_VIRTUALENV_ROOT=$HOME/.virtualenvs
fi

function venv_list() {
    if [ -z "$MY_VIRTUALENV_ROOT" ]; then
        export MY_VIRTUALENV_ROOT=$HOME/.virtualenvs
    fi
    cd $MY_VIRTUALENV_ROOT;
    ls -d | grep -v .
}

function venv_create() {
    local venv_name=$1
    if [ -z "$venv_name" ]; then
        venv_name=$(basename `pwd`)
        echo "Usage: create_venv <venv_name>"
        echo "[Warning] You didn't specify venv name"
        echo "Auto using $venv_name as your venv_name"
    fi
    if [ -z "$MY_VIRTUALENV_ROOT" ]; then
        export MY_VIRTUALENV_ROOT=$HOME/.virtualenvs
    fi
    if [ ! -d "$MY_VIRTUALENV_ROOT" ]; then
        mkdir -p $MY_VIRTUALENV_ROOT;
    fi
    cd $MY_VIRTUALENV_ROOT;
    python3 -m venv $venv_name;
    $MY_VIRTUALENV_ROOT/$venv_name/bin/pip install --upgrade pip
    generate_venv_aliases
    cd - > /dev/null
}

function venv_source() {
    if [ -z "$MY_VIRTUALENV_ROOT" ]; then
        export MY_VIRTUALENV_ROOT=$HOME/.virtualenvs
    fi
    local venv_name=$1
    if [ -z $venv_name ]; then
        venv_name=$(basename `pwd`)
    fi
    source $MY_VIRTUALENV_ROOT/$venv_name/bin/activate
}


if [ -d $MY_DEV_ROOT ]; then
    generate_dev_aliases
fi

if [ -d $MY_VIRTUALENV_ROOT ]; then
    generate_venv_aliases
fi

