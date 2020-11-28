export ENV_ROOT=$(cd `dirname ${0:a}`/.. && pwd)

source $ENV_ROOT/inc/common.sh
source $ENV_ROOT/inc/env.sh
source $ENV_ROOT/inc/route.sh
source $ENV_ROOT/inc/net.sh
source $ENV_ROOT/inc/ssh.sh
source $ENV_ROOT/inc/ufw.sh
source $ENV_ROOT/inc/venv.sh
source $ENV_ROOT/inc/display.sh
source $ENV_ROOT/inc/git-prompt.sh
source $ENV_ROOT/inc/fzf.sh
source $ENV_ROOT/inc/rdp-remote.sh
source $ENV_ROOT/inc/docker.sh
source $ENV_ROOT/inc/launcher.sh
source $ENV_ROOT/inc/install.sh
source $ENV_ROOT/inc/settings.sh
source $ENV_ROOT/inc/aliases.sh

source $ENV_ROOT/env/zsh/variables.zsh
source $ENV_ROOT/env/zsh/util.zsh
source $ENV_ROOT/env/zsh/statusbar.zsh
source $ENV_ROOT/env/zsh/settings.zsh
