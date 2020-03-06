set txtred = "%{\e[0;30;31m%}"
set txtgrn = "%{\e[0;30;32m%}"
set txtylw = "%{\e[0;30;33m%}"
set txtblu = "%{\e[0;30;34m%}"
set txtpur = "%{\e[0;30;35m%}"
set txtwht = "%{\e[0;30;37m%}"
set txtrst = "%{\e[0m%}"
set who    = "${txtred}`whoami`$txtrst"
set host   = "$txtylw%M$txtrst"
set apwd   = "$txtgrn%~$txtrst"
set date   = "$txtpur%P %Y/%W/%D$txtrst"
set at     = "$txtwht@$txtrst"
set gitrev = `sh -c 'git rev-parse --abbrev-ref HEAD 2> /dev/null'`
#set sh_in_use = `ps | grep --color=none $$ | awk '{print $(NF)}'`
set sh_in_use = `echo $0 | sed 's/-//'`
if ( "$gitrev" != "" ) then
    set gitprompt = "$txtblu$gitrev$txtrst"
    set prompt = "${who}${at}${host}:${apwd} ($gitprompt) [${date}] $txtrst($sh_in_use)\n# "
else
    set prompt = "${who}${at}${host}:${apwd} [${date}] $txtrst($sh_in_use)\n# "
endif
alias precmd "source `lsof +p $$ | grep -oE /.\*prompt.csh`"
