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
set venv   = ""
set gitrev = `git branch |& grep '*' |& sed 's/^\* *//g'`
set sh_in_use = "${txtblu}(`echo $0 | sed 's/-//'`)${txtrst}"
if ( $?VIRTUAL_ENV ) then
    set venv = "[`basename ${VIRTUAL_ENV}`] "
else
    set venv = ""
endif
if ( "${gitrev}" != "" ) then
    set branch = "${txtcyn}${gitrev}${txtrst}"
    set prompt = "${venv}${who}${at}${host}:${apwd} ($branch) [${datetime}] ${sh_in_use} \n%L%# "
else
    set prompt = "${venv}${who}${at}${host}:${apwd} [${datetime}] ${sh_in_use} \n%L%# "
endif
# alias precmd "source `lsof +p $$ |& grep -oE /.\*statusbar.csh` >& /dev/null"
alias precmd 'source $ENV_ROOT/inc/tcsh/statusbar.csh >& /dev/null'
