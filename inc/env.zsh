function env_use_common () {
    source $ENV_ROOT/inc/base.sh
}

function env_use_core () {
    source $ENV_ROOT/inc/zsh/variables.zsh
    source $ENV_ROOT/inc/zsh/util.zsh
    source $ENV_ROOT/inc/zsh/statusbar.zsh
    source $ENV_ROOT/inc/zsh/settings.zsh
}

function env_use_basic () {
    source $ENV_ROOT/inc/env.sh
    source $ENV_ROOT/inc/net.sh
    source $ENV_ROOT/inc/venv.sh
    source $ENV_ROOT/inc/aliases.sh
    source $ENV_ROOT/inc/tmux.sh
}

function env_use_extra () {
    source $ENV_ROOT/inc/route.sh
    source $ENV_ROOT/inc/ssh.sh
    source $ENV_ROOT/inc/ufw.sh
    source $ENV_ROOT/inc/display.sh
    source $ENV_ROOT/inc/git-prompt.sh
    source $ENV_ROOT/inc/git-aliases.sh
    source $ENV_ROOT/inc/fzf.sh
    source $ENV_ROOT/inc/rdp-remote.sh
    source $ENV_ROOT/inc/docker.sh
    source $ENV_ROOT/inc/launcher.sh
    source $ENV_ROOT/inc/install.sh
    source $ENV_ROOT/inc/config.sh
    source $ENV_ROOT/inc/settings.sh
    source $ENV_ROOT/inc/production.sh
    source $ENV_ROOT/inc/pdf.sh
}

function env_use_min () {
    env_use_common
    env_use_core
}

function env_use_all () {
    env_use_common
    env_use_core
    env_use_basic
    env_use_extra
}

