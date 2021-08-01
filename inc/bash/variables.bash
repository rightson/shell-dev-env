if [[ `uname` = 'Linux' ]]; then
    export PROFILE=$HOME/.bashrc
else # Darwin
    export PROFILE=$HOME/.bash_profile
fi
