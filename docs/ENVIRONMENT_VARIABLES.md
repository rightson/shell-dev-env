# Environment Variables Reference

Complete reference for all environment variables used and managed by `shell-dev-env`.

## Table of Contents

- [Core Variables](#core-variables)
- [Path Variables](#path-variables)
- [Editor Variables](#editor-variables)
- [Shell Variables](#shell-variables)
- [Terminal Variables](#terminal-variables)
- [History Variables](#history-variables)
- [Development Variables](#development-variables)
- [Feature Flags](#feature-flags)
- [Shell-Specific Variables](#shell-specific-variables)
- [Proposed Variables (Future)](#proposed-variables-future)

## Core Variables

### ENV_ROOT

**Type**: String (Path)
**Set by**: `shell-dev-env` automatically
**Used in**: All modules

The root directory of the shell-dev-env installation.

```bash
# Example
export ENV_ROOT=/home/user/.env
```

**Usage**:
- Source path for all included modules
- Base for `$ENV_ROOT/bin` utilities
- Reference point for updates (`env_self_update`)

### SHELL_PATH

**Type**: String (Path)
**Set by**: `shell-dev-env` automatically
**Used in**: Shell detection

Full path to the current shell binary.

```bash
# Examples
export SHELL_PATH=/bin/bash
export SHELL_PATH=/usr/bin/zsh
```

### SHELL_NAME

**Type**: String
**Set by**: `shell-dev-env` automatically
**Used in**: Shell-specific logic

Name of the current shell (basename of SHELL_PATH).

```bash
# Examples
export SHELL_NAME=bash
export SHELL_NAME=zsh
export SHELL_NAME=tcsh
```

### PROFILE_PATH

**Type**: String (Path)
**Set by**: Shell-specific modules
**Used in**: Configuration updates

Path to the shell's RC file.

```bash
# Bash on Linux
export PROFILE_PATH=$HOME/.bashrc

# Bash on macOS
export PROFILE_PATH=$HOME/.bash_profile

# Zsh
export PROFILE_PATH=~/.zshrc

# Tcsh
setenv PROFILE_PATH ~/.cshrc
```

## Path Variables

### PATH

**Type**: Colon-separated paths
**Modified by**: `inc/settings.sh`, `inc/env.sh`
**Purpose**: Executable search path

**Default structure** (in priority order):
```bash
$HOME/.local/bin       # User pip/pipx packages
$HOME/local/bin        # User binaries
$ENV_ROOT/bin          # shell-dev-env utilities
[Original PATH]        # System PATH
/usr/local/bin         # Local installations (unless NO_USER_LOCAL=1)
/usr/local/sbin        # Local system binaries
```

**Functions that modify PATH**:
- `registerPath(dir)` - Prepend directory to PATH
- `uniqueify_PATH()` - Remove duplicates from PATH

### LD_LIBRARY_PATH

**Type**: Colon-separated paths
**Modified by**: `inc/env.sh`
**Purpose**: Shared library search path (Linux)

```bash
# Example
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
```

**Functions**:
- `registerLibrary(dir)` - Prepend directory
- `uniqueify_LD_LIBRARY_PATH()` - Remove duplicates

### MANPATH

**Type**: Colon-separated paths
**Purpose**: Manual page search path

```bash
# Example
export MANPATH=$PREFIX/share/man:$MANPATH
```

### PKG_CONFIG_PATH

**Type**: Colon-separated paths
**Purpose**: pkg-config search path

```bash
# Example (proposed)
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH
```

## Editor Variables

### EDITOR

**Type**: String (Command)
**Default**: `/usr/bin/vim`
**Set in**: `inc/settings.sh`

Primary text editor for command-line editing.

```bash
export EDITOR=/usr/bin/vim
```

**Used by**: Git, SVN, cron, mail clients, etc.

### VISUAL

**Type**: String (Command)
**Default**: `/usr/bin/vim`
**Set in**: `inc/settings.sh`

Visual (full-screen) editor.

```bash
export VISUAL=/usr/bin/vim
```

**Difference from EDITOR**: Historically, `EDITOR` was line-based (ed), `VISUAL` was full-screen (vi/vim). Modern systems treat them the same.

### VIM_BIN

**Type**: String (Path)
**Default**: `/usr/bin/vim`
**Set in**: `inc/settings.sh`

Path to vim binary.

```bash
export VIM_BIN=/usr/bin/vim
```

### GIT_EDITOR

**Type**: String (Command)
**Default**: `/usr/bin/vim`
**Set in**: `inc/tcsh/setting.csh` (tcsh), derived from `$EDITOR` in bash/zsh

Git's preferred editor.

```bash
# Tcsh
setenv GIT_EDITOR /usr/bin/vim

# Bash/Zsh (via git config)
git config --global core.editor vim
```

### SVN_EDITOR

**Type**: String (Command)
**Default**: `$EDITOR`
**Set in**: `inc/settings.sh`

Subversion's preferred editor.

```bash
export SVN_EDITOR=$EDITOR
```

## Shell Variables

### BASH_VERSION

**Type**: String
**Set by**: Bash automatically
**Used for**: Shell detection

Bash version string. Only exists in bash.

```bash
# Example
echo $BASH_VERSION
# 5.2.15(1)-release
```

### ZSH_VERSION

**Type**: String
**Set by**: Zsh automatically
**Used for**: Shell detection

Zsh version string. Only exists in zsh.

```bash
# Example
echo $ZSH_VERSION
# 5.9
```

### ZSH_NAME

**Type**: String
**Set by**: Zsh automatically

Name of the shell (zsh).

### ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE

**Type**: String (Color)
**Default**: `fg=cyan`
**Set in**: `inc/zsh/variables.zsh`

Highlight color for zsh-autosuggestions.

```zsh
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=cyan
```

## Terminal Variables

### TERM

**Type**: String
**Default**: `xterm-256color`
**Set in**: `inc/settings.sh`

Terminal type identifier.

```bash
export TERM=xterm-256color
```

**Purpose**: Tells programs what terminal capabilities are available (colors, cursor movement, etc.)

### LANG

**Type**: String (Locale)
**Default**: `en_US.UTF-8`
**Set in**: `inc/settings.sh`

Primary locale setting.

```bash
export LANG=en_US.UTF-8
```

### LC_ALL

**Type**: String (Locale)
**Default**: `$LANG`
**Set in**: `inc/settings.sh`

Override for all locale settings.

```bash
export LC_ALL=${LANG}
```

### LC_CTYPE

**Type**: String (Locale)
**Default**: `en_US.UTF-8`
**Set in**: `inc/settings.sh`

Character type locale (encoding).

```bash
export LC_CTYPE=en_US.UTF-8
```

### GREP_COLOR

**Type**: String (Color code)
**Default**: `"1;33"` (bold yellow)
**Set in**: `inc/settings.sh`

Color for grep matches.

```bash
export GREP_COLOR="1;33"
```

## History Variables

### HISTCONTROL

**Type**: String (Colon-separated options)
**Default**: `ignoreboth`
**Set in**: `inc/settings.sh`
**Shell**: Bash

Controls what gets saved to history.

```bash
export HISTCONTROL=ignoreboth
# ignoreboth = ignoredups + ignorespace
# ignoredups: don't save duplicate commands
# ignorespace: don't save commands starting with space
```

### HISTSIZE

**Type**: Integer
**Default**: `100000`
**Set in**: `inc/settings.sh`
**Shell**: Bash

Maximum number of commands in memory.

```bash
export HISTSIZE=100000
```

### HISTFILESIZE

**Type**: Integer
**Default**: `200000`
**Set in**: `inc/settings.sh`
**Shell**: Bash

Maximum number of commands in history file.

```bash
export HISTFILESIZE=200000
```

### SAVEHIST

**Type**: Integer
**Default**: `200000`
**Set in**: `inc/settings.sh`
**Shell**: Zsh

Maximum number of commands to save (zsh equivalent of HISTFILESIZE).

```bash
export SAVEHIST=200000
```

### HISTFILE

**Type**: String (Path)
**Default**: `~/.bash_history` (bash), `~/.zsh_history` (zsh)
**Modified by**: `inc/history.sh` (when in tmux)

Path to history file.

**When in tmux**, modified to include pane ID:
```bash
# Example
HISTFILE=~/.bash_history.pane.%0
```

## Development Variables

### GOPATH

**Type**: String (Path)
**Default**: Not set by shell-dev-env
**Set by**: User or `set_go_path()` function

Go workspace directory.

```bash
export GOPATH=$HOME/go
```

**Related PATH modification**:
```bash
export PATH=$GOPATH/bin:$PATH
```

### GOBIN

**Type**: String (Path)
**Default**: `$GOPATH/bin`
**Proposed in**: docs/PROPOSAL.md

Go binary installation directory.

```bash
export GOBIN=$GOPATH/bin
```

### MY_VIRTUALENV_ROOT

**Type**: String (Path)
**Default**: `$HOME/.virtualenvs`
**Set in**: `inc/venv.sh`

Root directory for Python virtual environments.

```bash
export MY_VIRTUALENV_ROOT=$HOME/.virtualenvs
```

### MY_DEV_ROOT

**Type**: String (Path)
**Default**: `$HOME/workspace`
**Set in**: `inc/venv.sh`

Root directory for development projects.

```bash
export MY_DEV_ROOT=$HOME/workspace
```

### TMUX_PANE

**Type**: String
**Set by**: Tmux automatically
**Used in**: `inc/history.sh`

Current tmux pane identifier (e.g., `%0`, `%1`, `%2`).

**Used for**: Per-pane history file separation.

## Feature Flags

These variables control shell-dev-env behavior. Set them **before** sourcing shell-dev-env.

### NO_USER_LOCAL

**Type**: Integer (0 or 1)
**Default**: `0` (false)
**Set in**: User's environment (before sourcing)
**Used in**: `inc/settings.sh`

Disable adding `/usr/local/bin` and `/usr/local/sbin` to PATH.

```bash
# In your .bashrc, BEFORE shell-dev-env
export NO_USER_LOCAL=1
```

**Use case**: When `/usr/local` paths cause conflicts or you want minimal PATH.

## Shell-Specific Variables

### Bash Variables

**PS1** - Primary prompt
**PS2** - Secondary prompt (continuation)
**BASH_COMPLETION_COMPAT_DIR** - Bash completion directory

### Zsh Variables

**PROMPT** - Primary prompt (zsh equivalent of PS1)
**RPROMPT** - Right-side prompt
**ZSH_THEME** - Oh-My-Zsh theme (if using Oh-My-Zsh)

### Tcsh Variables

**prompt** - tcsh prompt
**cwd** - Current working directory (tcsh built-in)

## Exit Code Variables

### EXIT_SUCCESS

**Type**: Integer
**Default**: `0`
**Set in**: `inc/base.sh`

Success exit code constant.

```bash
export EXIT_SUCCESS=0
```

### EXIT_FAILURE

**Type**: Integer
**Default**: `-1`
**Set in**: `inc/base.sh`

Failure exit code constant.

```bash
export EXIT_FAILURE=-1
```

## Proposed Variables (Future)

These variables are proposed in docs/PROPOSAL.md but not yet implemented.

### XDG Base Directory Variables

```bash
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"
```

**Purpose**: Standards-compliant user directory organization.

### Homebrew Variables

```bash
export HOMEBREW_PREFIX="$(brew --prefix)"
export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX"
```

**Purpose**: Dynamic Homebrew installation detection.

### Language-Specific Variables

#### Rust/Cargo

```bash
export CARGO_HOME="${CARGO_HOME:-$HOME/.cargo}"
export RUSTUP_HOME="${RUSTUP_HOME:-$HOME/.rustup}"
```

#### Node.js/npm

```bash
export NPM_CONFIG_PREFIX="${NPM_CONFIG_PREFIX:-$HOME/.npm-global}"
export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"
```

#### Python

```bash
export PYTHON_USER_BASE="$(python3 -m site --user-base)"
export POETRY_HOME="${POETRY_HOME:-$HOME/.local/share/poetry}"
```

#### Ruby

```bash
export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
```

### Installation Prefix

```bash
export PREFIX="${PREFIX:-$HOME/.local}"
```

**Purpose**: Custom installation prefix for compiled software.

### Feature Flags (Proposed)

```bash
export NO_HOMEBREW="${NO_HOMEBREW:-0}"              # Skip Homebrew paths
export NO_LANGUAGE_PATHS="${NO_LANGUAGE_PATHS:-0}"  # Skip language paths
export NO_PKG_MANAGERS="${NO_PKG_MANAGERS:-0}"      # Skip snap/flatpak
export USE_MINIMAL_PATH="${USE_MINIMAL_PATH:-0}"    # Minimal PATH only
export XDG_COMPLIANCE="${XDG_COMPLIANCE:-0}"        # Enable XDG support
export HOMEBREW_AUTO_DETECT="${HOMEBREW_AUTO_DETECT:-0}"  # Auto-detect Homebrew
export LANGUAGE_ENV_SUPPORT="${LANGUAGE_ENV_SUPPORT:-0}"  # Language envs
```

## Setting Environment Variables

### Before Installation

Set in your existing `~/.bashrc` or `~/.zshrc` **before** the shell-dev-env installation:

```bash
# Feature flags
export NO_USER_LOCAL=1

# Custom paths
export MY_DEV_ROOT="$HOME/projects"
export MY_VIRTUALENV_ROOT="$HOME/.venvs"
```

### After Installation

Set in your RC file **after** the shell-dev-env block:

```bash
# shell-dev-env block
# =Begin=
...
# =End=

# Your custom variables
export GOPATH="$HOME/go"
export EDITOR="nvim"
```

### Session-Only

Set in your current shell (not persistent):

```bash
export HISTSIZE=50000
uniqueify_PATH
```

## Inspecting Variables

### View all environment variables

```bash
env                    # All environment variables
printenv               # Same as env
export -p              # Bash: exported variables
declare -x             # Bash: alternative
```

### View specific variable

```bash
echo $PATH
echo $EDITOR
printenv PATH
```

### View in pretty format

```bash
# View PATH as list
echo $PATH | tr ':' '\n'

# View all env vars sorted
env | sort

# Search for specific prefix
env | grep -i hist
```

## Environment Variable Precedence

1. **Shell built-ins** (highest priority)
   - Set by shell itself (BASH_VERSION, ZSH_VERSION)

2. **User's RC file (before shell-dev-env)**
   - Feature flags set here

3. **shell-dev-env defaults**
   - Set in `inc/settings.sh` and other modules

4. **User's RC file (after shell-dev-env)**
   - Overrides for customization

5. **Session variables** (lowest persistence)
   - Set in current shell only

## Best Practices

### 1. Use defaults when available

```bash
# GOOD: Use default with fallback
export PREFIX="${PREFIX:-$HOME/.local}"

# AVOID: Hardcoding
export PREFIX=$HOME/.local
```

### 2. Check before modifying critical vars

```bash
# GOOD: Preserve existing
export PATH="$HOME/bin:$PATH"

# AVOID: Replacing
export PATH="$HOME/bin"
```

### 3. Document custom variables

```bash
# Set Go workspace to custom location for project organization
export GOPATH="$HOME/projects/go"
```

### 4. Use consistent naming

```bash
# GOOD: Clear, standard names
export MY_PROJECT_ROOT="$HOME/projects/myapp"

# AVOID: Unclear abbreviations
export MPR="$HOME/projects/myapp"
```

## Debugging

### Check if variable is set

```bash
if [ -z "$GOPATH" ]; then
    echo "GOPATH is not set"
else
    echo "GOPATH=$GOPATH"
fi
```

### Check variable source

```bash
# Bash
type HISTSIZE
declare -p HISTSIZE

# Any shell
echo "HISTSIZE=$HISTSIZE"
```

### Track variable changes

```bash
# Before
echo "PATH before: $PATH"

# Make changes
source ~/.bashrc

# After
echo "PATH after: $PATH"
```

## Summary Table

| Variable | Default | Purpose | Set By |
|----------|---------|---------|---------|
| `ENV_ROOT` | Auto-detected | shell-dev-env root | shell-dev-env |
| `PATH` | Multi-component | Executable search | shell-dev-env + user |
| `EDITOR` | `/usr/bin/vim` | Default editor | shell-dev-env |
| `TERM` | `xterm-256color` | Terminal type | shell-dev-env |
| `HISTSIZE` | `100000` | History in memory | shell-dev-env |
| `HISTFILESIZE` | `200000` | History in file | shell-dev-env |
| `LANG` | `en_US.UTF-8` | Primary locale | shell-dev-env |
| `NO_USER_LOCAL` | `0` | Feature flag | User |
| `GOPATH` | Not set | Go workspace | User |

## See Also

- [PATH_MANAGEMENT.md](PATH_MANAGEMENT.md) - Detailed PATH guide
- [FEATURES.md](FEATURES.md) - Complete feature list
- [PROPOSAL.md](PROPOSAL.md) - Proposed improvements
- [README.md](../README.md) - Installation guide

---

**Last Updated**: 2025-11-15
