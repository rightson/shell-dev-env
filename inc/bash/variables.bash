if [[ `uname` = 'Linux' ]]; then
    export PROFILE_PATH=$HOME/.bashrc
else # Darwin
    export PROFILE_PATH=$HOME/.bash_profile
fi
