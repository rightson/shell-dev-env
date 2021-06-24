set txtred = "%{\e[0;30;31m%}"
set txtgrn = "%{\e[0;30;32m%}"
set txtylw = "%{\e[0;30;33m%}"
set txtblu = "%{\e[0;30;34m%}"
set txtpur = "%{\e[0;30;35m%}"
set txtcyn = "%{\e[0;30;36m%}"
set txtwht = "%{\e[0;30;37m%}"
set txtrst = "%{\e[0m%}"
set who    = "${txtred}`whoami`${txtrst}"
set host   = "${txtylw}%M${txtrst}"
set apwd   = "${txtgrn}%~${txtrst}"
set datetime = "${txtpur}%P %Y/%W/%D${txtrst}"
set at     = "${txtwht}@${txtrst}"
#set gitrev = `sh -c 'git rev-parse --abbrev-ref HEAD 2> /dev/null'`
set gitrev = `git branch |& grep '*' |& sed 's/^\* *//g' >& /dev/null`
#set sh_in_use = `ps | grep --color=none $$ | awk '{print $(NF)}'`
set sh_in_use = "${txtblu}(`echo $0 | sed 's/-//'`)${txtrst}"
if ( "${gitrev}" != "" ) then
    set gitprompt = "${txtcyn}${gitrev}${txtrst}"
    set prompt = "${who}${at}${host}:${apwd} ($gitprompt) [${datetime}] ${sh_in_use} \n\r# "
else
    set prompt = "${who}${at}${host}:${apwd} [${datetime}] ${sh_in_use} \n\r# "
endif
alias precmd "source `lsof +p $$ |& grep -oE /.\*statusbar.csh` >& /dev/null"
