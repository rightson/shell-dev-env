#!/bin/bash
# prettfy PS1 in bash


txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
bldblk='\e[1;30m' # Black - Bold
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White
unkblk='\e[4;30m' # Black - Underline
undred='\e[4;31m' # Red
undgrn='\e[4;32m' # Green
undylw='\e[4;33m' # Yellow
undblu='\e[4;34m' # Blue
undpur='\e[4;35m' # Purple
undcyn='\e[4;36m' # Cyan
undwht='\e[4;37m' # White
bakblk='\e[40m'   # Black - Background
bakred='\e[41m'   # Red
badgrn='\e[42m'   # Green
bakylw='\e[43m'   # Yellow
bakblu='\e[44m'   # Blue
bakpur='\e[45m'   # Purple
bakcyn='\e[46m'   # Cyan
bakwht='\e[47m'   # White
txtrst='\e[0m'    # Text Reset

function get_ipaddr()
{
    local interface=
    local ip=
    for i in `seq 0 1 10`; do
        if [ `uname` = 'Linux' ]; then
            interface="eth${i}"
            ip=`/sbin/ifconfig | grep -A1 -e "^$interface" | tail -n 1`
        else
            interface="en${i}"
            ip=`/sbin/ifconfig | grep -A3 -e "^$interface" | tail -n 1 | awk '{print $2}'`
        fi
        if [[ $ip =~ ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}) ]]; then
            echo ${BASH_REMATCH[1]};
            return
        fi
    done
    echo 'localhost'
}

user="$txtred\u$txtrst"
#host="$txtblu`get_ipaddr`$txtrst"
host="$txtylw\h$txtrst"
rpwd="$txtgrn\w$txtrst"
opwd="$txtgrn\W$txtrst"
datetime="$txtpur[\t \D{%Y/%m/%d}]$txtrst"
at="$txtwht@$txtrst"
#sh_in_use=`ps | grep --color=none $$ | awk '{print $(NF)}'`
sh_in_use="$txtblu(`echo $0 | sed 's/-//' | xargs basename`)$txtrst"
function git_ps1() {
    # gitcb runs faster than __git_ps1
    local name=`git branch 2> /dev/null | grep '*' 2> /dev/null | cut -d' ' -f2-`
    if [ -n "$name" ]; then
        echo "($name)"
    else
        echo ""
    fi
}

#PS1="${user}${at}${host}:${rpwd}${txtcyn}"'`__git_ps1`'"${txtrst} ${datetime} ${sh_in_use}\r\n\$ "
PS1="${user}${at}${host}:${rpwd} ${txtcyn}"'`git_ps1`'"${txtrst} ${datetime} ${sh_in_use}\r\n\$ "
