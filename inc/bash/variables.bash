if [[ `uname` = 'Linux' ]]; then
    export PROFILE='~/.bashrc'
else # Darwin
    export PROFILE='~/.bash_profile'
fi
