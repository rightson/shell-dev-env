# aliases


ENV_PATH=~/.my-env
SIMPLE_HTTP='python -m SimpleHTTPServer 8000'
LOCAL_BIN='~/bin'
if [ `uname` == 'Linux' ]; then
    export BASH_RCFILE='~/.bashrc'

    alias ls='ls --color'
    alias grep='grep -rn --color'
    alias du1='sudo du -h --max-depth 1'
else
    export BASH_RCFILE='~/.bash_profile'

    alias ls='ls -G'
    alias grep='grep --color'
    alias du1='sudo du -h -d1'
fi

alias so="unalias -a ; . ${BASH_RCFILE}"
alias virc="vim ${ENV_PATH}"

alias kill-vnc='vncserver -kill'
alias kill-ssh='killall -9 ssh'
alias clean-swp='rm -f .*.swp'

# Command with default arguments
alias mv='mv -i'
alias scp='scp -r'
alias wget='wget -c'
alias tree='tree -C'
alias vncserver='vncserver -geometry 1400x900'
alias vncviewer='vncviewer -encoding Tight -quality 9'


# Shortcut commands
alias l='ls -lCF'
alias l.='ls -ld .*'
alias la='ls -A'
alias ll='ls -l'
alias lh='ls -lh'
alias lj='ls -lh ~/jobs'
alias x='exit'
alias al='alias'
alias ual='unalias -a; . ~/.bashrc; alias'
alias steal='sudo chown -R `id -u`:`id -g`'
alias 755='sudo chmod -R 755'
alias ka='while [ 1 ]; do echo -ne "\rKeeping Connection Alive (`date`)" ; sleep 10; done'
alias py=python
alias simple-http="echo $SIMPLE_HTTP; $SIMPLE_HTTP"


# Shortcuts for svn cmd line
if [ -d ${LOCAL_BIN} ]; then
    alias svndiff="svn di --diff-cmd ${LOCAL_BIN}/svndiff.sh"
    alias s=".  ${LOCAL_BIN}/list_svn_diff.sh set'
    alias sc=". ${LOCAL_BIN}/list_svn_diff.sh set check'
    alias sr=". ${LOCAL_BIN}/list_svn_diff.sh reset'
fi
alias st='svn status'
alias stq='svn status -q'
alias svnup="find . -type d | grep -v .svn | xargs svn up"


# Shortcuts for remote access
alias reverse-ln='ssh -D 8888 -N -f rightson@rightson.org'
alias 2is='ssh is90246@alumni.cis.nctu.edu.tw'
alias 2dorm7='ssh rightson@dorm7.com'
alias 2ln='ssh rightson@rightson.org'
alias 2build-machine='ssh scott@10.32.48.162'

