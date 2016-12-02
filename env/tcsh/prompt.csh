
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
set prompt = "${who}${at}${host}:${apwd}[${date}]\n$txtrst# "

