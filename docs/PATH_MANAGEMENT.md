# PATH Management Guide

This guide explains how `shell-dev-env` manages the PATH environment variable and how you can customize it for your needs.

## Table of Contents

- [Overview](#overview)
- [Default PATH Order](#default-path-order)
- [PATH Management Functions](#path-management-functions)
- [Customization Options](#customization-options)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Overview

The PATH environment variable tells your shell where to look for executable programs. `shell-dev-env` carefully manages PATH to ensure:

1. **User binaries take precedence** - Your custom tools override system defaults
2. **No duplicates** - Built-in deduplication prevents PATH bloat
3. **Platform awareness** - macOS and Linux differences handled automatically
4. **Extensibility** - Easy to add custom paths programmatically

## Default PATH Order

When you source `shell-dev-env`, your PATH is constructed in this order (highest to lowest priority):

### 1. User-specific binaries
```bash
$HOME/.local/bin          # XDG-compliant user binaries (pip, pipx, etc.)
$HOME/local/bin           # Alternative user binary location
```

### 2. Shell-dev-env binaries
```bash
$ENV_ROOT/bin             # Utilities provided by shell-dev-env
```

### 3. System binaries (original PATH)
```bash
$PATH                     # Your original system PATH preserved
```

### 4. Local installation directories (optional)
```bash
/usr/local/bin            # Added unless NO_USER_LOCAL=1
/usr/local/sbin           # Added unless NO_USER_LOCAL=1
```

### Complete PATH Example (Linux)

```bash
# After sourcing shell-dev-env, your PATH might look like:
/home/user/.local/bin:
/home/user/local/bin:
/home/user/.env/bin:
/usr/local/bin:
/usr/local/sbin:
/usr/bin:
/bin:
/usr/sbin:
/sbin
```

## PATH Management Functions

`shell-dev-env` provides several functions for managing PATH (defined in `inc/env.sh`):

### registerPath()

Adds a directory to the beginning of PATH with validation.

**Usage:**
```bash
registerPath /path/to/bin
```

**Features:**
- ✅ Validates path exists before adding
- ✅ Prepends to PATH (highest priority)
- ✅ Shows error if path doesn't exist
- ✅ Returns exit code for error handling

**Example:**
```bash
# Add custom tool directory
if registerPath "$HOME/mytools/bin"; then
    echo "Successfully added mytools to PATH"
fi
```

### registerLibrary()

Adds a directory to LD_LIBRARY_PATH (Linux) or DYLD_LIBRARY_PATH (macOS).

**Usage:**
```bash
registerLibrary /path/to/lib
```

**Features:**
- ✅ Validates path exists
- ✅ Prepends to LD_LIBRARY_PATH
- ✅ Critical for shared library loading

**Example:**
```bash
# Add custom library directory
registerLibrary "$HOME/mytools/lib"
```

### registerPathAndLibrary()

Convenience function that registers both bin/ and lib/ subdirectories.

**Usage:**
```bash
registerPathAndLibrary /path/to/prefix
```

**What it does:**
- Calls `registerPath /path/to/prefix/bin`
- Calls `registerLibrary /path/to/prefix/lib`

**Example:**
```bash
# Install custom software to $HOME/opt/myapp with bin/ and lib/
registerPathAndLibrary "$HOME/opt/myapp"
# Now $HOME/opt/myapp/bin is in PATH
# And $HOME/opt/myapp/lib is in LD_LIBRARY_PATH
```

### set_go_path()

Sets up Go language environment variables.

**Usage:**
```bash
set_go_path /path/to/go/workspace
```

**What it does:**
- Sets `GOPATH` to specified directory
- Adds `$GOPATH/bin` to PATH
- Echoes the GOPATH value

**Example:**
```bash
# Set up Go workspace
set_go_path "$HOME/projects/go"
# Now GOPATH=$HOME/projects/go
# And $HOME/projects/go/bin is in PATH
```

### uniqueify_PATH()

Removes duplicate entries from PATH.

**Usage:**
```bash
uniqueify_PATH
```

**Features:**
- ✅ Preserves order (keeps first occurrence)
- ✅ Works in both bash and zsh
- ✅ Safe to call multiple times
- ✅ Handles edge cases (empty entries, special characters)

**Example:**
```bash
# After sourcing multiple tools that modify PATH
echo $PATH
# /usr/bin:/usr/local/bin:/usr/bin:/home/user/bin

uniqueify_PATH

echo $PATH
# /usr/bin:/usr/local/bin:/home/user/bin
```

### uniqueify_LD_LIBRARY_PATH()

Same as uniqueify_PATH but for LD_LIBRARY_PATH.

**Usage:**
```bash
uniqueify_LD_LIBRARY_PATH
```

### uniqueify_path() (Advanced)

Generic function to remove duplicates from any colon-separated environment variable.

**Usage:**
```bash
new_value=$(uniqueify_path VARIABLE_NAME)
export VARIABLE_NAME="$new_value"
```

**Example:**
```bash
# Clean up MANPATH
export MANPATH=$(uniqueify_path MANPATH)
```

## Customization Options

### Option 1: Feature Flags

Set these **before** sourcing shell-dev-env:

```bash
# In your ~/.bashrc or ~/.zshrc, BEFORE the shell-dev-env block

# Disable adding /usr/local to PATH
export NO_USER_LOCAL=1

# Then source shell-dev-env
source ~/.env/seeds/bashrc  # or wherever it's sourced
```

### Option 2: Add Custom Paths

Add custom paths **after** sourcing shell-dev-env:

```bash
# In your ~/.bashrc or ~/.zshrc, AFTER the shell-dev-env block

# Add custom tool directories
registerPath "$HOME/bin"
registerPath "$HOME/.cargo/bin"
registerPath "$HOME/go/bin"

# Add a complete software installation
registerPathAndLibrary "$HOME/opt/custom-software"

# Clean up any duplicates
uniqueify_PATH
```

### Option 3: Conditional Paths

Add paths only when certain conditions are met:

```bash
# Add Homebrew paths on macOS
if [[ "$OSTYPE" == "darwin"* ]] && command -v brew &> /dev/null; then
    BREW_PREFIX="$(brew --prefix)"
    registerPath "$BREW_PREFIX/bin"
    registerPath "$BREW_PREFIX/sbin"
fi

# Add Rust cargo if installed
if [ -d "$HOME/.cargo/bin" ]; then
    registerPath "$HOME/.cargo/bin"
fi

# Add Go binaries if Go is installed
if command -v go &> /dev/null; then
    set_go_path "$HOME/go"
fi

# Clean up
uniqueify_PATH
```

### Option 4: Modify Settings File (Advanced)

For permanent changes that apply to all shells, edit:

```bash
~/.env/inc/settings.sh
```

**Example custom settings:**

```bash
# Add your customizations to inc/settings.sh

# Add additional default paths
export PATH="$HOME/bin:$PATH"

# Set up language environments
if command -v cargo &> /dev/null; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

if command -v go &> /dev/null; then
    export GOPATH="$HOME/go"
    export PATH="$GOPATH/bin:$PATH"
fi

# Clean up
uniqueify_PATH
```

## Best Practices

### 1. **Order Matters**

Directories are searched left-to-right. Put more specific/custom paths first:

```bash
# GOOD: Custom path first
export PATH="$HOME/mytools/bin:$PATH"

# BAD: Custom path last (might be shadowed)
export PATH="$PATH:$HOME/mytools/bin"
```

### 2. **Check Before Adding**

Always verify directories exist to avoid errors:

```bash
# GOOD: Check first
if [ -d "$HOME/custom/bin" ]; then
    registerPath "$HOME/custom/bin"
fi

# BETTER: Use registerPath (has built-in checking)
registerPath "$HOME/custom/bin"

# AVOID: Blindly adding paths
export PATH="$HOME/custom/bin:$PATH"  # Error if doesn't exist
```

### 3. **Deduplicate Regularly**

Call `uniqueify_PATH` after adding multiple paths:

```bash
registerPath "$HOME/bin"
registerPath "$HOME/.local/bin"
registerPath "$HOME/.cargo/bin"
uniqueify_PATH  # Clean up any duplicates
```

### 4. **Use Absolute Paths**

Always use absolute paths, not relative ones:

```bash
# GOOD
registerPath "$HOME/mytools/bin"
registerPath "/opt/custom/bin"

# BAD (relative paths can break)
registerPath "mytools/bin"
registerPath "./bin"
```

### 5. **Language-Specific Environments**

Use dedicated environment variables for languages:

```bash
# Go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Rust
export CARGO_HOME="$HOME/.cargo"
export PATH="$CARGO_HOME/bin:$PATH"

# Node.js (global npm packages)
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"

# Python (pip user packages)
export PATH="$HOME/.local/bin:$PATH"

# Ruby
export GEM_HOME="$HOME/.gem"
export PATH="$GEM_HOME/bin:$PATH"
```

## Troubleshooting

### Problem: Command not found after installation

**Check if directory is in PATH:**
```bash
echo $PATH | tr ':' '\n' | grep myapp
```

**Check if executable exists:**
```bash
ls -la $HOME/myapp/bin/
```

**Try adding explicitly:**
```bash
registerPath "$HOME/myapp/bin"
which myapp
```

### Problem: Wrong version of command running

**Check which version is being used:**
```bash
which python
# /usr/bin/python

which -a python  # Show ALL matches in PATH
# /usr/bin/python
# /usr/local/bin/python
# /home/user/.local/bin/python
```

**Solution: Adjust PATH order**
```bash
# Put desired path first
export PATH="/home/user/.local/bin:$PATH"
uniqueify_PATH
which python
# /home/user/.local/bin/python
```

### Problem: Duplicate PATH entries

**Check for duplicates:**
```bash
echo $PATH | tr ':' '\n' | sort | uniq -d
```

**Solution:**
```bash
uniqueify_PATH
```

### Problem: PATH too long

**Check PATH length:**
```bash
echo ${#PATH}  # Show character count
```

**Solution: Clean up**
```bash
# Remove unnecessary paths
export NO_USER_LOCAL=1
source ~/.bashrc

# Or manually reconstruct minimal PATH
export PATH="/usr/local/bin:/usr/bin:/bin"
registerPath "$HOME/.local/bin"
```

### Problem: Changes don't persist

**Make sure changes are in your shell RC file:**

For bash (Linux):
```bash
# Add to ~/.bashrc
registerPath "$HOME/mytools/bin"
```

For bash (macOS):
```bash
# Add to ~/.bash_profile
registerPath "$HOME/mytools/bin"
```

For zsh:
```bash
# Add to ~/.zshrc
registerPath "$HOME/mytools/bin"
```

**Reload your shell:**
```bash
source ~/.bashrc  # or ~/.zshrc or ~/.bash_profile
```

### Problem: registerPath fails silently

**Check if directory exists:**
```bash
ls -ld "$HOME/mytools/bin"
```

**Check return value:**
```bash
if ! registerPath "$HOME/mytools/bin"; then
    echo "Failed to register path!"
    echo "Does it exist? $(ls -ld $HOME/mytools/bin 2>&1)"
fi
```

## Advanced Topics

### Custom PATH Management Function

Create your own helper function:

```bash
# Add to your ~/.bashrc after shell-dev-env

function add_to_path() {
    local dir="$1"
    if [ -d "$dir" ] && [[ ":$PATH:" != *":$dir:"* ]]; then
        export PATH="$dir:$PATH"
    fi
}

# Usage
add_to_path "$HOME/bin"
add_to_path "$HOME/.local/bin"
```

### Platform-Specific PATH

```bash
# Add to your ~/.bashrc after shell-dev-env

case "$(uname -s)" in
    Darwin)
        # macOS-specific paths
        registerPath "/opt/homebrew/bin"
        registerPath "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
        ;;
    Linux)
        # Linux-specific paths
        registerPath "/snap/bin"
        registerPath "$HOME/.local/share/flatpak/exports/bin"
        ;;
esac
uniqueify_PATH
```

### Lazy Loading for Performance

For expensive operations (like `brew --prefix`), cache the result:

```bash
# Cache expensive commands
if [ -z "$BREW_PREFIX_CACHED" ]; then
    if command -v brew &> /dev/null; then
        export BREW_PREFIX_CACHED="$(brew --prefix)"
    fi
fi

if [ -n "$BREW_PREFIX_CACHED" ]; then
    registerPath "$BREW_PREFIX_CACHED/bin"
fi
```

## Summary

- Use `registerPath()` to safely add directories to PATH
- Call `uniqueify_PATH()` to remove duplicates
- Set feature flags before sourcing shell-dev-env
- Add custom paths after sourcing shell-dev-env
- Always use absolute paths
- Check if directories exist before adding them
- Path order matters - more specific paths should come first

## See Also

- [FEATURES.md](FEATURES.md) - Complete feature list
- [ENVIRONMENT_VARIABLES.md](ENVIRONMENT_VARIABLES.md) - All environment variables
- [PROPOSAL.md](../PROPOSAL.md) - Proposed improvements to PATH management
- [README.md](../README.md) - Installation and quick start

---

**Last Updated**: 2025-11-15
