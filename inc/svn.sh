# SVN

SVN_TOOL_PATH=$ENV_ROOT/bin
if [ -d ${SVN_TOOL_PATH} ]; then
    alias svndiff="svn di --diff-cmd ${SVN_TOOL_PATH}/svn-diff.sh"
    alias s=".  ${SVN_TOOL_PATH}/list-svn-diff.sh set"
    alias sc=". ${SVN_TOOL_PATH}/list-svn-diff.sh set check"
    alias sr=". ${SVN_TOOL_PATH}/list-svn-diff.sh reset"
fi

alias st='svn status'
alias stq='svn status -q'
alias svnup="find . -type d | grep -v .svn | xargs svn up"

