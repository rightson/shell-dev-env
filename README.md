# Shell Development Environment

**`shell-dev-env`** is an all-in-one, modular shell configuration management system for Unix-like environments (Linux, macOS). It provides a consistent, feature-rich shell experience across multiple shells with smart PATH management, Git integration, and extensive customization options.

[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS-blue)]()
[![Shells](https://img.shields.io/badge/shells-bash%20%7C%20zsh%20%7C%20tcsh-green)]()

## Features

- **Multi-Shell Support**: bash, zsh, tcsh/csh with shell-specific optimizations
- **Smart PATH Management**: Intelligent PATH construction with deduplication and validation
- **Non-Destructive Installation**: Automatic backups, clearly marked modifications
- **Git Integration**: 20+ Git aliases, custom configurations, and helper scripts
- **Tmux Support**: Enhanced configuration with per-pane history
- **Rich Aliases**: 50+ productivity shortcuts for common tasks
- **Cross-Platform**: Works on Linux (all distros) and macOS (Intel & Apple Silicon)
- **Modular Design**: 30+ independent modules you can selectively enable
- **Extensive Documentation**: Comprehensive guides for all features

## Quick Start

### Installation

**1. Clone the repository:**
```bash
git clone https://github.com/rightson/shell-dev-env.git ~/.env
```

**2. Install (full installation with dependencies):**

Linux/macOS:
```bash
bash ~/.env/shell-env.sh
```

Windows (PowerShell):
```powershell
powershell ~\.env\shell-env.ps1
```

**3. Patch only (no dependency installation):**
```bash
bash ~/.env/shell-env.sh patch
```

**4. Reload your shell:**

Linux/macOS:
```bash
source $PROFILE_PATH
# or
exec $SHELL
```

Windows:
```powershell
. $PROFILE
```

That's it! Enjoy your enhanced shell environment.

## What Gets Installed

`shell-dev-env` automatically patches these configuration files (with backups):

- **Shell RC files**: `~/.bashrc`, `~/.bash_profile`, `~/.zshrc`, `~/.cshrc`
- **Vim/Neovim**: `~/.vimrc`, `~/.config/nvim/init.vim`
- **Tmux**: `~/.tmux.conf`
- **Screen**: `~/.screenrc`

All modifications are clearly marked with begin/end markers and timestamps:

```bash
# =======================================================================
# Added by shell-env.sh utility. Date: 2025-11-15 10:30:00
# =Begin=

[Configuration from shell-dev-env]

# =End=
# =======================================================================
```

**Backups** are automatically created:
```
~/.bashrc-2025-11-15-10-30-00.bak
~/.vimrc-2025-11-15-10-30-00.bak
```

## Documentation

### Core Documentation

- **[PROPOSAL.md](PROPOSAL.md)** - Comprehensive proposal for PATH improvements using default environment variables
- **[docs/FEATURES.md](docs/FEATURES.md)** - Complete feature reference with examples
- **[docs/PATH_MANAGEMENT.md](docs/PATH_MANAGEMENT.md)** - Detailed PATH management guide
- **[docs/ENVIRONMENT_VARIABLES.md](docs/ENVIRONMENT_VARIABLES.md)** - All environment variables reference

### Quick Links

- [Feature Flags](#feature-flags)
- [Customization](#customization)
- [PATH Management](#path-management)
- [Git Aliases](#git-integration)
- [Tmux Integration](#tmux-support)
- [Troubleshooting](#troubleshooting)

## Feature Highlights

### Smart PATH Management

Default PATH structure (priority order):

```bash
$HOME/.local/bin          # User pip/pipx packages
$HOME/local/bin           # User binaries
$ENV_ROOT/bin             # shell-dev-env utilities
[Original PATH]           # System PATH preserved
/usr/local/bin            # Local installations (optional)
/usr/local/sbin           # Local system binaries (optional)
```

**Functions provided**:
- `registerPath(dir)` - Add directory to PATH with validation
- `registerLibrary(dir)` - Add to LD_LIBRARY_PATH
- `registerPathAndLibrary(prefix)` - Add both bin/ and lib/
- `uniqueify_PATH()` - Remove duplicate PATH entries
- `set_go_path(path)` - Set up Go environment

**Example usage**:
```bash
# Add custom tool directory
registerPath "$HOME/mytools/bin"

# Add software with libraries
registerPathAndLibrary "/opt/custom-software"

# Set up Go workspace
set_go_path "$HOME/go"

# Clean up duplicates
uniqueify_PATH
```

See [docs/PATH_MANAGEMENT.md](docs/PATH_MANAGEMENT.md) for detailed guide.

### Git Integration

**20+ Git aliases** configured automatically:

```bash
git s         # status
git st        # status -uno
git lg        # pretty log graph
git co        # checkout
git br        # branch
git ci        # commit
git df        # diff
git last      # show last commit
git gmb       # git merge_by (custom)
```

**Custom scripts** in `bin/`:
- `git-rename.sh` - Batch rename with Git tracking
- `svn-diff.sh` - SVN-style diff for Git

**Auto-configured settings**:
- Color UI enabled
- Vim as default editor
- Smart push defaults

### Tmux Support

Enhanced tmux configuration with:

- **256 color support**
- **Custom status bar**
- **Mouse support**
- **Vi-mode keys**
- **Per-pane history** - Each tmux pane gets its own command history

**Aliases**:
```bash
ta 'name'        # Attach to session
ts 'name'        # New session
tl               # List sessions
tn               # New pane in current window
```

### Rich Aliases

**Navigation**:
```bash
..               # cd ..
...              # cd ../..
ll               # ls -alF
la               # ls -A
```

**Homebrew (macOS)**:
```bash
brew-start       # brew services start
brew-stop        # brew services stop
brew-restart     # brew services restart
brew-list        # brew services list
```

**Safety**:
```bash
rm               # rm -i (interactive)
cp               # cp -i (interactive)
mv               # mv -i (interactive)
```

See [docs/FEATURES.md](docs/FEATURES.md) for complete list.

## Feature Flags

Control behavior by setting variables **before** sourcing shell-dev-env:

### Current Flags

```bash
# Disable /usr/local paths
export NO_USER_LOCAL=1
```

### Proposed Flags (See PROPOSAL.md)

```bash
# Skip language-specific environment variables (Go, Rust, Node, etc.)
export NO_LANGUAGE_PATHS=1

# Enable XDG Base Directory compliance (default: enabled)
export XDG_COMPLIANCE=1

# Enable PREFIX variable support (default: enabled)
export PREFIX_SUPPORT=1

# Set custom PREFIX location (default: $HOME/.local)
export PREFIX=/opt/myapp
```

## Customization

### Add Custom Paths

In your `~/.bashrc` or `~/.zshrc` **after** the shell-dev-env block:

```bash
# Add custom tool directories
registerPath "$HOME/bin"
registerPath "$HOME/.cargo/bin"

# Add language environments
if command -v go &> /dev/null; then
    set_go_path "$HOME/go"
fi

# Clean up duplicates
uniqueify_PATH
```

### Customize Environment Variables

```bash
# Set custom editor
export EDITOR=nvim
export VISUAL=nvim

# Set custom development root
export MY_DEV_ROOT="$HOME/projects"

# Set custom virtualenv root
export MY_VIRTUALENV_ROOT="$HOME/.venvs"
```

### Platform-Specific Customization

```bash
case "$(uname -s)" in
    Darwin)
        # macOS-specific settings
        export HOMEBREW_NO_AUTO_UPDATE=1
        ;;
    Linux)
        # Linux-specific settings
        export DISPLAY=:0
        ;;
esac
```

## Shell Support

| Shell | Support | Config File | Notes |
|-------|---------|-------------|-------|
| **bash** | ✅ Full | `~/.bashrc` (Linux) <br> `~/.bash_profile` (macOS) | Primary target |
| **zsh** | ✅ Full | `~/.zshrc` | Oh-My-Zsh compatible |
| **tcsh/csh** | ✅ Full | `~/.cshrc` | Complete C-shell support |
| **PowerShell** | ⚠️ Partial | `$PROFILE` | Windows support |

## Platform Support

- **Linux**: Ubuntu, Debian, Arch, Fedora, CentOS, and all major distributions
- **macOS**: Intel and Apple Silicon (M1/M2/M3) Macs
- **Windows**: Partial support via PowerShell

## Project Structure

```
shell-dev-env/
├── README.md                 # This file
├── PROPOSAL.md              # Comprehensive improvement proposal
├── shell-env.sh             # Main installation script (Linux/macOS)
├── shell-env.ps1            # PowerShell variant (Windows)
│
├── docs/                    # Documentation
│   ├── FEATURES.md          # Complete feature reference
│   ├── PATH_MANAGEMENT.md   # PATH management guide
│   └── ENVIRONMENT_VARIABLES.md  # Environment variable reference
│
├── inc/                     # Core modules (~25 files)
│   ├── base.sh              # Common utilities
│   ├── settings.sh          # Main PATH and environment setup
│   ├── env.sh               # PATH management functions
│   ├── aliases.sh           # Common aliases
│   ├── history.sh           # History configuration
│   ├── git.sh               # Git integration
│   ├── tmux.sh              # Tmux configuration
│   ├── bash/                # Bash-specific (3 files)
│   ├── zsh/                 # Zsh-specific (9 files)
│   ├── tcsh/                # Tcsh-specific (4 files)
│   └── [additional modules] # Docker, FZF, SSH, etc.
│
├── seeds/                   # Template RC files
│   ├── bashrc               # Bash template
│   ├── zshrc                # Zsh template
│   ├── cshrc                # Csh template
│   ├── nvimrc               # Neovim config
│   ├── tmux.conf            # Tmux config
│   └── screenrc             # Screen config
│
├── bin/                     # Utility scripts (12 files)
│   ├── cs                   # Color scheme utility
│   ├── git-rename.sh        # Git-aware renaming
│   ├── uniq-path.sh         # Remove duplicate PATH entries
│   └── [other utilities]
│
└── vim/                     # Vim configurations
```

## Updating

### Update from Git

Use the built-in update function:

```bash
env_self_update
```

This will:
1. Navigate to `$ENV_ROOT`
2. Run `git pull`
3. Return to your previous directory

### Manual Update

```bash
cd ~/.env
git pull
source ~/.bashrc  # or ~/.zshrc
```

## Uninstalling

To uninstall shell-dev-env:

1. **Remove marked sections** from your RC files:
   - Open `~/.bashrc` (or `~/.zshrc`, etc.)
   - Delete everything between the `# =Begin=` and `# =End=` markers
   - Save the file

2. **Or restore from backup**:
   ```bash
   # Find your backup
   ls -t ~/.bashrc-*.bak | head -1

   # Restore it
   cp ~/.bashrc-2025-11-15-10-30-00.bak ~/.bashrc
   ```

3. **Reload your shell**:
   ```bash
   source ~/.bashrc
   # or
   exec $SHELL
   ```

4. **Optionally remove the directory**:
   ```bash
   rm -rf ~/.env
   ```

## Troubleshooting

### Command not found after installation

**Check if directory is in PATH**:
```bash
echo $PATH | tr ':' '\n'
```

**Add missing directory**:
```bash
registerPath "$HOME/myapp/bin"
```

### Wrong version of command running

**Check which version**:
```bash
which -a python  # Show all matches
```

**Fix PATH order**:
```bash
export PATH="$HOME/.local/bin:$PATH"
uniqueify_PATH
```

### Changes don't persist

Make sure changes are in your RC file:
- **Bash (Linux)**: `~/.bashrc`
- **Bash (macOS)**: `~/.bash_profile`
- **Zsh**: `~/.zshrc`

Then reload:
```bash
source ~/.bashrc  # or appropriate RC file
```

### PATH has duplicates

```bash
# Check for duplicates
echo $PATH | tr ':' '\n' | sort | uniq -d

# Remove duplicates
uniqueify_PATH
```

See [docs/PATH_MANAGEMENT.md](docs/PATH_MANAGEMENT.md) for more troubleshooting.

## Advanced Usage

### Custom Installation Prefix

```bash
# Install software to custom location
export PREFIX="$HOME/.local"
./configure --prefix=$PREFIX
make install

# Add to PATH
registerPathAndLibrary "$PREFIX"
```

### Language-Specific Environments

```bash
# Go
export GOPATH="$HOME/go"
set_go_path "$GOPATH"

# Rust
export CARGO_HOME="$HOME/.cargo"
registerPath "$CARGO_HOME/bin"

# Node.js
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
registerPath "$NPM_CONFIG_PREFIX/bin"

# Python
registerPath "$HOME/.local/bin"  # Already included by default
```

### Conditional Loading

```bash
# Only load if command exists
if command -v docker &> /dev/null; then
    source $ENV_ROOT/inc/docker.sh
fi

# Only on specific platform
if [[ "$OSTYPE" == "darwin"* ]]; then
    source $ENV_ROOT/inc/macos-specific.sh
fi
```

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes with clear commit messages
4. Test on multiple shells/platforms if possible
5. Submit a pull request

See [PROPOSAL.md](PROPOSAL.md) for planned improvements and areas where contributions are needed.

## Roadmap

See [PROPOSAL.md](PROPOSAL.md) for the practical, docker-friendly improvement plan, including:

- **XDG Base Directory Specification** support (industry standard, container-friendly)
- **PREFIX variable support** (build system standard)
- **Language environment variables** (Go, Rust, Node.js, Python - no auto-detection)
- **Zero dependencies** - No complex detection logic
- **100% backward compatible** - All improvements are opt-in via environment variables
- **Docker-first approach** - Works in containers without modification

## Breaking Changes

**Note**: The shell-dev-env was rewritten entirely. For those updating from legacy versions, please remove legacy patches from existing RC files manually before installing the new version.

## Requirements

- **Unix-like OS**: Linux, macOS, or Unix
- **Shell**: bash 3.2+, zsh 5.0+, or tcsh/csh
- **Git**: For installation and updates
- **Vim** (optional): For editor integration
- **Tmux** (optional): For enhanced tmux features

## License

This project is provided as-is for personal and commercial use. See the repository for license details.

## Support

- **Documentation**: See [docs/](docs/) directory
- **Issues**: Report bugs or request features via GitHub issues
- **Questions**: Check documentation first, then open an issue

## Author

Created and maintained by [Rightson](https://github.com/rightson)

## Acknowledgments

Thanks to all contributors and users who have helped improve shell-dev-env over the years.

---

**Quick Links**:
- [Installation](#installation)
- [Documentation](#documentation)
- [Features](docs/FEATURES.md)
- [PATH Management](docs/PATH_MANAGEMENT.md)
- [Environment Variables](docs/ENVIRONMENT_VARIABLES.md)
- [Improvement Proposal](PROPOSAL.md)

**Last Updated**: 2025-11-15
