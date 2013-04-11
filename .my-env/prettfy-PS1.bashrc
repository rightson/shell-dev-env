#!/bin/bash
# bash color


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
    if [ `uname` == 'Linux' ]; then
        local interface='eth0'
        local ip=`/sbin/ifconfig | grep -A1 -e "^$interface" | tail -n 1` 
        if [[ $ip =~ .*addr:([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}).* ]]; then 
            echo ${BASH_REMATCH[1]}; 
        else
            echo 'localhost'
        fi
    else
        local interface='en0'
        local ip=`/sbin/ifconfig | grep -A3 -e "^$interface" | tail -n 1 | awk '{print $2}'` 
        echo $ip
    fi
}

root="$txtred\u$txtrst"
user="$txtred\u$txtrst"
host="$txtblu`get_ipaddr`$txtrst"
rpwd="$txtgrn\w$txtrst"
opwd="$txtgrn\W$txtrst"
date="$txtpur\t$txtrst"
at="$txtwht@$txtrst"

if [ "`id -u`" -eq 0 ]; then
    PS1="${root}@${host}[\w]# "
else
    PS1="${user}${at}${host}:${rpwd}\n\$ "
fi 

