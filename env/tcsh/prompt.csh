set txtred = "%{\e[0;30;31m%}"
set txtgrn = "%{\e[0;30;32m%}"
set txtylw = "%{\e[0;30;33m%}"
set txtblu = "%{\e[0;30;34m%}"
set txtpur = "%{\e[0;30;35m%}"
set txtwht = "%{\e[0;30;37m%}"
set txtrst = "%{\e[0m%}"
set who    = "${txtred}`whoami`$txtrst"
set host   = "$txtblu%M$txtrst"
set apwd   = "$txtgrn%~$txtrst"
set date   = "$txtpur%p$txtrst"
set at     = "$txtwht@$txtrst"
set gitrev = `sh -c 'git rev-parse --abbrev-ref HEAD 2> /dev/null'`
if ( "$gitrev" != "" ) then
    set gitprompt = "$txtylw$gitrev$txtrst"
    set prompt = "${who}${at}${host}:${apwd}[${date}][$gitprompt]\n$txtrst# "
else
    set prompt = "${who}${at}${host}:${apwd}[${date}]\n$txtrst# "
endif
alias precmd "source `/usr/sbin/lsof +p $$ | grep -oE /.\*prompt.csh`"
