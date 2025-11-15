# Shell-Dev-Env Features

Complete feature reference for `shell-dev-env` - your all-in-one shell configuration management system.

## Table of Contents

- [Core Features](#core-features)
- [Shell Support](#shell-support)
- [Configuration Management](#configuration-management)
- [Environment Management](#environment-management)
- [Aliases & Shortcuts](#aliases--shortcuts)
- [Git Integration](#git-integration)
- [Tmux Integration](#tmux-integration)
- [History Management](#history-management)
- [Editor Configuration](#editor-configuration)
- [Development Tools](#development-tools)
- [Utility Functions](#utility-functions)
- [Platform-Specific Features](#platform-specific-features)

## Core Features

### Multi-Shell Support

`shell-dev-env` works seamlessly across multiple shells:

| Shell | Support Level | Config File | Notes |
|-------|--------------|-------------|-------|
| **bash** | ✅ Full | `~/.bashrc` (Linux) / `~/.bash_profile` (macOS) | Primary development target |
| **zsh** | ✅ Full | `~/.zshrc` | Enhanced Oh-My-Zsh compatible features |
| **tcsh/csh** | ✅ Full | `~/.cshrc` | Complete C-shell support |
| **PowerShell** | ⚠️ Partial | `$PROFILE` | Windows support via `shell-env.ps1` |

### Cross-Platform Compatibility

- **Linux**: Ubuntu, Debian, Arch, Fedora, CentOS
- **macOS**: Intel and Apple Silicon (M1/M2/M3)
- **Windows**: PowerShell support (partial)

### Non-Destructive Installation

- **Automatic backups**: RC files backed up with timestamp before modification
- **Marked sections**: All modifications clearly marked with begin/end markers
- **Easy removal**: Clean removal possible by deleting marked sections
- **Idempotent**: Safe to run installation multiple times

## Shell Support

### Bash-Specific Features

**Files**: `inc/bash/variables.bash`, `inc/bash/util.bash`, `inc/bash/statusbar.bash`

- **Platform detection**: Automatic detection of Linux vs macOS
- **Custom prompt (PS1)**: Rich, colorful status line showing:
  - Username and hostname
  - Current directory with shortened path
  - Git branch and status
  - Exit code of last command
- **Bash completion**: Enhanced tab completion
- **History management**: Optimized history settings

### Zsh-Specific Features

**Files**: `inc/zsh/` (9 files)

- **Oh-My-Zsh compatible**: Works alongside Oh-My-Zsh
- **Autosuggestions**: Fish-style autosuggestions
  - Highlight color: cyan (customizable via `ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE`)
- **Enhanced completion**: Advanced tab completion
- **Custom prompt**: Powerline-style prompt with Git info
- **Syntax highlighting**: Real-time command syntax highlighting

### Tcsh/Csh Support

**Files**: `inc/tcsh/` (4 files)

- **C-shell syntax**: Native tcsh/csh configuration
- **Prompt customization**: tcsh-compatible prompts
- **Aliases**: Common aliases ported to C-shell syntax
- **Environment setup**: PATH and environment variables

## Configuration Management

### RC File Patching

**Module**: `inc/patch.sh`

Automatically patches and manages configuration files:

- `~/.bashrc` / `~/.bash_profile`
- `~/.zshrc`
- `~/.cshrc`
- `~/.vimrc` / `~/.config/nvim/init.vim`
- `~/.tmux.conf`
- `~/.screenrc`

**How it works**:
```bash
# Marked sections in your RC files
# =======================================================================
# Added by shell-env.sh utility. Date: 2025-11-15 10:30:00
# =Begin=

[Configuration from shell-dev-env]

# =End=
# =======================================================================
```

**Backup format**:
```
~/.bashrc-2025-11-15-10-30-00.bak
~/.vimrc-2025-11-15-10-30-00.bak
```

### Installation Modes

**Full installation** (installs dependencies):
```bash
bash ~/.env/shell-env.sh
```

**Patch only** (no dependency installation):
```bash
bash ~/.env/shell-env.sh patch
```

**Update from Git**:
```bash
env_self_update  # Function provided by shell-dev-env
```

## Environment Management

### PATH Management

**Module**: `inc/env.sh`, `inc/settings.sh`

**Default PATH structure**:
```
$HOME/.local/bin          # User pip/pipx packages
$HOME/local/bin           # User binaries
$ENV_ROOT/bin             # shell-dev-env utilities
[Original PATH]           # System PATH preserved
/usr/local/bin            # Local installations (unless NO_USER_LOCAL=1)
/usr/local/sbin           # Local system binaries
```

**Functions**:
- `registerPath(dir)` - Add directory to PATH
- `registerLibrary(dir)` - Add to LD_LIBRARY_PATH
- `registerPathAndLibrary(prefix)` - Add both bin/ and lib/
- `uniqueify_PATH()` - Remove duplicate PATH entries
- `uniqueify_LD_LIBRARY_PATH()` - Remove duplicate library paths

**See**: [PATH_MANAGEMENT.md](PATH_MANAGEMENT.md) for detailed guide.

### Environment Variables

**Module**: `inc/settings.sh`

**Editor configuration**:
```bash
VIM_BIN=/usr/bin/vim
EDITOR=$VIM_BIN
SVN_EDITOR=$EDITOR
VISUAL=$VIM_BIN
```

**Terminal settings**:
```bash
TERM=xterm-256color
LANG=en_US.UTF-8
LC_ALL=${LANG}
LC_CTYPE=en_US.UTF-8
GREP_COLOR="1;33"
```

**History settings**:
```bash
HISTCONTROL=ignoreboth    # Ignore duplicates and spaces
HISTSIZE=100000           # Lines in memory
HISTFILESIZE=200000       # Lines in file
SAVEHIST=200000           # Zsh history size
```

**See**: [ENVIRONMENT_VARIABLES.md](ENVIRONMENT_VARIABLES.md) for complete reference.

## Aliases & Shortcuts

**Module**: `inc/aliases.sh`

### Directory Navigation

```bash
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
```

### Homebrew Services (macOS)

```bash
alias brew-start='brew services start'
alias brew-stop='brew services stop'
alias brew-restart='brew services restart'
alias brew-list='brew services list'
```

### Safety Aliases

```bash
alias rm='rm -i'          # Prompt before delete
alias cp='cp -i'          # Prompt before overwrite
alias mv='mv -i'          # Prompt before overwrite
```

### System Monitoring

```bash
alias df='df -h'          # Human-readable disk usage
alias du='du -h'          # Human-readable directory size
alias free='free -h'      # Human-readable memory (Linux)
```

### Quick Editors

```bash
alias vi='vim'
alias svi='sudo vi'
alias edit='$EDITOR'
```

## Git Integration

**Module**: `inc/git.sh`, `inc/config.sh`

### Git Aliases

**Defined via `git config`**:

```bash
# Status and info
git s               # git status
git st              # git status -uno (ignore untracked)

# Logging
git lg              # Pretty, colorful log graph
git last            # Show last commit

# Branching
git co              # checkout
git br              # branch
git ba              # branch -a (all branches)

# Committing
git ci              # commit
git cam             # commit -am (commit all with message)

# Diffing
git df              # diff
git dfc             # diff --cached

# Merging
git gmb             # git merge_by (custom merge alias)
```

### Git Configuration

Auto-configured settings:
```bash
core.editor = vim
color.ui = auto
push.default = simple
pull.rebase = false
```

### Custom Git Scripts

**Location**: `bin/`

- `git-rename.sh` - Batch rename files with Git tracking
- `svn-diff.sh` - SVN-style diff for Git repositories

## Tmux Integration

**Module**: `inc/tmux.sh`

### Tmux Configuration

**Config file**: `seeds/tmux.conf`

**Features**:
- **256 color support**: Full color terminal
- **Custom status bar**: Shows session, window, pane info
- **Mouse support**: Click to switch panes
- **Vi-mode keys**: Vi-style copy mode
- **Pane management**: Easy pane splitting and navigation

### Tmux Aliases

```bash
alias ta='tmux attach -t'      # Attach to session
alias tad='tmux attach -d -t'  # Attach and detach others
alias ts='tmux new-session -s' # New session
alias tl='tmux list-sessions'  # List sessions
alias tksv='tmux kill-server'  # Kill server
alias tkss='tmux kill-session -t' # Kill session

# Pane shortcuts
alias tn='tmux-new-pane'       # New pane in current window
```

### Per-Pane History

**Module**: `inc/history.sh`

When in tmux, shell history is separated per pane:

```bash
# Each tmux pane gets its own history file:
~/.bash_history.pane.%0
~/.bash_history.pane.%1
~/.bash_history.pane.%2
```

**Benefits**:
- Independent history per pane
- Context-preserved history
- No history pollution between panes

## History Management

**Module**: `inc/history.sh`

### Settings

**Bash**:
```bash
HISTCONTROL=ignoreboth    # Ignore duplicates and leading spaces
HISTSIZE=100000           # Commands in memory
HISTFILESIZE=200000       # Commands in file
```

**Zsh**:
```bash
HISTSIZE=100000
SAVEHIST=200000
setopt SHARE_HISTORY      # Share history across sessions
setopt HIST_IGNORE_DUPS   # Don't record duplicates
setopt HIST_FIND_NO_DUPS  # Don't show duplicates in search
```

### Features

- **Large history**: 100k-200k commands stored
- **Duplicate prevention**: No duplicate commands stored
- **Tmux integration**: Per-pane history in tmux sessions
- **Persistent**: History saved across sessions
- **Searchable**: Ctrl+R for reverse history search

## Editor Configuration

### Vim/Neovim

**Module**: `inc/config.sh`, `seeds/nvimrc`

**Config files managed**:
- `~/.vimrc` - Traditional Vim
- `~/.config/nvim/init.vim` - Neovim

**Features**:
- Syntax highlighting
- Line numbers
- Auto-indentation
- Tab settings (4 spaces)
- Search highlighting
- Incremental search
- Mouse support

### Editor Environment Variables

```bash
EDITOR=vim
VISUAL=vim
GIT_EDITOR=vim
SVN_EDITOR=vim
```

## Development Tools

### Virtual Environment Support

**Module**: `inc/venv.sh`

**Python virtual environments**:
```bash
MY_VIRTUALENV_ROOT=$HOME/.virtualenvs

# Workspace directory
MY_DEV_ROOT=$HOME/workspace
```

### Language-Specific Setup

**Go**:
```bash
set_go_path ~/go           # Sets GOPATH and adds $GOPATH/bin to PATH
```

**Custom installations**:
```bash
registerPathAndLibrary /opt/custom-software
# Adds /opt/custom-software/bin to PATH
# Adds /opt/custom-software/lib to LD_LIBRARY_PATH
```

### Docker Integration

**Module**: `inc/docker.sh`

Docker-related aliases and functions:
```bash
alias dps='docker ps'
alias di='docker images'
alias drm='docker rm'
alias drmi='docker rmi'
```

### FZF Integration

**Module**: `inc/fzf.sh`

Fuzzy finder integration:
- Command history search (Ctrl+R enhanced)
- File navigation
- Directory jumping

## Utility Functions

### System Information

**Hardware temperature** (Linux):
```bash
get_hw_temp
# Output: Lists thermal zone temperatures
```

**Platform detection**:
```bash
# Automatic detection used throughout:
- Linux: ~/.bashrc
- macOS: ~/.bash_profile
```

### Color Schemes

**Script**: `bin/cs`

Color scheme utility for terminal customization.

### Path Uniqueification

```bash
# Remove duplicates from PATH
uniqueify_PATH

# Remove duplicates from any colon-separated variable
export MANPATH=$(uniqueify_path MANPATH)
```

### Self-Update

```bash
env_self_update
# Updates shell-dev-env from Git repository
```

## Platform-Specific Features

### macOS-Specific

**Features**:
- Homebrew service management aliases
- Apple Silicon and Intel Mac support
- macOS keyboard binding support
- `.bash_profile` vs `.bashrc` handling

**Keyboard shortcuts**:
```bash
# Module: inc/keyboard.sh
# macOS-specific keyboard mappings
```

### Linux-Specific

**Features**:
- UFW firewall helpers
- Display/X11 configuration helpers
- Linux-specific paths (snap, flatpak, etc.)

**Modules**:
- `inc/ufw.sh` - UFW firewall shortcuts
- `inc/display.sh` - Display configuration helpers
- `inc/route.sh` - Network route helpers

## Feature Flags

Control features via environment variables (set before sourcing):

```bash
# Disable /usr/local paths
export NO_USER_LOCAL=1

# Custom environment root
export ENV_ROOT=/path/to/shell-dev-env
```

## Module Organization

### Core Modules (Always Loaded)

1. `base.sh` - Common utilities and error handling
2. `settings.sh` - Environment variables and PATH
3. `history.sh` - History configuration
4. `env.sh` - PATH management functions
5. `aliases.sh` - Common aliases

### Shell-Specific Modules

**Bash**: `bash/variables.bash`, `bash/util.bash`, `bash/statusbar.bash`
**Zsh**: `zsh/variables.zsh`, `zsh/util.zsh`, `zsh/statusbar.zsh`, etc.
**Tcsh**: `tcsh/variables.csh`, `tcsh/setting.csh`, etc.

### Optional Modules

6. `venv.sh` - Virtual environment support
7. `networking.sh` - Network utilities
8. `tmux.sh` - Tmux configuration
9. `git.sh` - Git integration
10. `config.sh` - Editor and tool configuration
11. `patch.sh` - RC file patching
12. `install.sh` - Dependency installation
13. `fzf.sh` - Fuzzy finder integration
14. `docker.sh` - Docker utilities
15. `ssh.sh` - SSH helpers
16. `ufw.sh` - Firewall configuration
17. `display.sh` - Display settings
18. `route.sh` - Network routing
19. `rdp.sh` - Remote desktop
20. `launcher.sh` - Application launcher helpers
21. `production.sh` - Production environment helpers
22. `pdf.sh` - PDF utilities

## Utility Scripts

**Location**: `bin/`

Available command-line utilities:

1. `cs` - Color scheme manager
2. `km.sh` - Keyboard mapping utility
3. `git-rename.sh` - Git-aware file renaming
4. `postgresql.sh` - PostgreSQL helpers
5. `svn-diff.sh` - SVN-style diff for Git
6. `uniq-path.sh` - Remove duplicate PATH entries
7. Additional utilities for specific tasks

## Configuration Files

### Templates (seeds/)

Template configuration files:

- `seeds/bashrc` - Bash RC template
- `seeds/zshrc` - Zsh RC template
- `seeds/cshrc` - C-shell RC template
- `seeds/nvimrc` - Neovim configuration
- `seeds/tmux.conf` - Tmux configuration
- `seeds/screenrc` - GNU Screen configuration

### Vim Configurations (vim/)

Vim-specific configuration files and plugins.

## Summary

`shell-dev-env` provides:

- ✅ **Multi-shell support** - bash, zsh, tcsh
- ✅ **Cross-platform** - Linux, macOS, Windows (partial)
- ✅ **Non-destructive** - Automatic backups, marked sections
- ✅ **Modular design** - 30+ independent modules
- ✅ **PATH management** - Smart, validated PATH handling
- ✅ **Rich aliases** - 50+ time-saving shortcuts
- ✅ **Git integration** - Aliases, configs, custom scripts
- ✅ **Tmux support** - Enhanced configuration and per-pane history
- ✅ **Editor configs** - Vim/Neovim ready-to-use settings
- ✅ **Development tools** - Python, Go, Docker, FZF support
- ✅ **Utility functions** - PATH deduplication, temperature monitoring, etc.
- ✅ **Customizable** - Feature flags and easy extension

## See Also

- [PATH_MANAGEMENT.md](PATH_MANAGEMENT.md) - Detailed PATH guide
- [ENVIRONMENT_VARIABLES.md](ENVIRONMENT_VARIABLES.md) - Environment variable reference
- [PROPOSAL.md](../PROPOSAL.md) - Planned improvements
- [README.md](../README.md) - Installation and quick start

---

**Last Updated**: 2025-11-15
