#/bin/bash

SVNDIFF="svn diff --diff-cmd /usr/local/bin/svn-diff.sh"
RM="sudo rm -rf"
TMPFILE=/tmp/svn_diff.list.$$

remove_file() {
    [ -f "${1}" ] && $RM ${1}
}

quit_handler() {
    remove_file $TMPFILE
    exit
}

trap quit_handler INT TERM EXIT

if [ "$1" == "set" ]; then
    echo 'svn st -q'

    filter="grep -v ^D"
    svn_files=`svn st -q | $filter | awk '{print $2;}'`

    echo -e "\nUse the following aliases (s1, s2...) to access changes\n"

    remove_file $TMPFILE
    id=0
    for each in ${svn_files}; do
        if [ -f "${each}" ]; then
            ((id++))
            cmd="alias s${id}='${SVNDIFF} ${each} '"
            [ "$2" = "check" ] && cmd="$cmd; sc" 
            echo $cmd
            echo $cmd >> $TMPFILE
        fi
    done
    [ -f $TMPFILE ] && source $TMPFILE
    remove_file $TMPFILE

elif [ "$1" == "reset" ]; then
    for ((i=1; i<100; i=i+1)) do
        alias "s$i" 2>/dev/null && unalias "s$i"
    done
    echo -e "\nRegistered aliases are cleaned now\n"


else
    echo -e "\nUsage:"
    echo -e "    source <this_file> set"
    echo -e "    source <this_file> reset\n"
fi
