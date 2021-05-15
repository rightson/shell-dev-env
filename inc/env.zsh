function use_env_common () {
    source $ENV_ROOT/inc/base.sh
}

function use_env_core () {
    source $ENV_ROOT/inc/zsh/variables.zsh
    source $ENV_ROOT/inc/zsh/util.zsh
    source $ENV_ROOT/inc/zsh/statusbar.zsh
    source $ENV_ROOT/inc/zsh/settings.zsh
}

function use_env_basic () {
    source $ENV_ROOT/inc/env.sh
    source $ENV_ROOT/inc/net.sh
    source $ENV_ROOT/inc/venv.sh
    source $ENV_ROOT/inc/aliases.sh
    source $ENV_ROOT/inc/tmux.sh
}

function use_env_extra () {
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

function use_env_min () {
    use_env_common
    use_env_core
}

function use_env_all () {
    use_env_common
    use_env_core
    use_env_basic
    use_env_extra
}

