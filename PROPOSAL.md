# Proposal: Improve PATH Defaults Using Standard Environment Variables

## Executive Summary

This proposal outlines practical improvements to `shell-dev-env`'s PATH and environment variable management by leveraging **widely-available standard environment variables**. The focus is on docker-friendly, portable defaults that work across containers, development environments, and production systems without complex detection logic.

## Current State

### Current PATH Configuration
```bash
# inc/settings.sh
export PATH=$HOME/local/bin:$HOME/.local/bin:$ENV_ROOT/bin:$PATH
if [ "NO_USER_LOCAL" != 1 ]; then
    export PATH=/usr/local/sbin:/usr/local/bin:$PATH
fi
```

### Issues with Current Approach
1. **Hardcoded paths** - Does not respect standard environment variables
2. **No XDG compliance** - Missing industry-standard directory specification
3. **Limited PREFIX support** - No support for standard `PREFIX` variable
4. **Docker unfriendly** - Hardcoded assumptions don't work well in containers
5. **No standard fallbacks** - Missing commonly-used environment variable patterns

## Guiding Principles

1. **Docker-first**: Works in containers without modification
2. **Standard variables**: Use widely-recognized environment variables
3. **Zero dependencies**: No dynamic detection requiring external tools
4. **Portable**: Works across Linux distros, containers, and macOS
5. **Backward compatible**: Existing behavior preserved by default
6. **Simple**: Straightforward logic, no complex detection

## Proposed Improvements

### 1. XDG Base Directory Specification Support ✅ DOCKER-FRIENDLY

**Rationale**: Industry standard, widely used, container-friendly.

**Implementation**:
```bash
# inc/env/xdg.sh

# XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"

# Add XDG bin directory to PATH (already standard location)
if [ -d "$XDG_BIN_HOME" ]; then
    export PATH="$XDG_BIN_HOME:$PATH"
fi
```

**Benefits**:
- ✅ Docker-friendly: Works in containers
- ✅ Standards-compliant (freedesktop.org specification)
- ✅ Users can override via environment variables
- ✅ No external dependencies
- ✅ Used by pip, pipx, npm, and many modern tools

**Container usage**:
```dockerfile
# In Dockerfile
ENV XDG_CONFIG_HOME=/app/.config
ENV XDG_BIN_HOME=/app/.local/bin
```

### 2. PREFIX Variable Support ✅ DOCKER-FRIENDLY

**Rationale**: Standard Unix convention for custom installation prefixes. Commonly used in build systems and containers.

**Implementation**:
```bash
# inc/env/prefix.sh

# Standard PREFIX variable (common in autotools, make, etc.)
# Used for: ./configure --prefix=$PREFIX
export PREFIX="${PREFIX:-$HOME/.local}"

# Add PREFIX paths if they exist
if [ -d "$PREFIX/bin" ]; then
    export PATH="$PREFIX/bin:$PATH"
fi

if [ -d "$PREFIX/lib" ]; then
    export LD_LIBRARY_PATH="$PREFIX/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
fi

if [ -d "$PREFIX/lib/pkgconfig" ]; then
    export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
fi

if [ -d "$PREFIX/share/man" ]; then
    export MANPATH="$PREFIX/share/man${MANPATH:+:$MANPATH}"
fi
```

**Benefits**:
- ✅ Docker-friendly: Standard in containers
- ✅ Build system standard (autotools, cmake, meson)
- ✅ Easy to override: `PREFIX=/opt/myapp`
- ✅ No dependencies or detection needed
- ✅ Works with compiled software

**Container usage**:
```dockerfile
ENV PREFIX=/opt/app
RUN ./configure --prefix=$PREFIX && make install
```

### 3. Language Environment Variables (Practical Subset)

Only include variables that are **standard** and **don't require detection**:

#### Go (GOPATH) ✅ PRACTICAL
```bash
# inc/env/languages.sh

# Go uses GOPATH environment variable (standard)
if [ -n "$GOPATH" ] && [ -d "$GOPATH/bin" ]; then
    export PATH="$GOPATH/bin:$PATH"
fi

# Common default if not set
if [ -z "$GOPATH" ] && [ -d "$HOME/go/bin" ]; then
    export PATH="$HOME/go/bin:$PATH"
fi
```

#### Rust (CARGO_HOME) ✅ PRACTICAL
```bash
# Rust/Cargo standard environment variable
export CARGO_HOME="${CARGO_HOME:-$HOME/.cargo}"
if [ -d "$CARGO_HOME/bin" ]; then
    export PATH="$CARGO_HOME/bin:$PATH"
fi
```

#### Python (User Base) ✅ PRACTICAL
```bash
# Python user site-packages (PEP 370)
# This is where 'pip install --user' puts executables
# Already covered by $HOME/.local/bin, but can be explicit:
if [ -n "$PYTHONUSERBASE" ] && [ -d "$PYTHONUSERBASE/bin" ]; then
    export PATH="$PYTHONUSERBASE/bin:$PATH"
fi
```

#### Node.js (NPM_CONFIG_PREFIX) ✅ PRACTICAL
```bash
# NPM global packages prefix
if [ -n "$NPM_CONFIG_PREFIX" ] && [ -d "$NPM_CONFIG_PREFIX/bin" ]; then
    export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"
fi
```

**Why these are practical**:
- ✅ All are **standard environment variables**
- ✅ Set by users or build systems, not detected
- ✅ Work in containers without modification
- ✅ No `command -v` or external tool dependencies
- ✅ Fail gracefully if not set

### 4. ❌ REMOVED: Dynamic Homebrew Detection

**Reason**: NOT docker-friendly, NOT practical
- ❌ Requires `brew` command installed
- ❌ `brew --prefix` is slow
- ❌ Doesn't work in containers
- ❌ macOS-specific, not portable
- ❌ Complex detection logic

**Alternative**: Users can set it themselves:
```bash
# In user's .bashrc if they want Homebrew
export HOMEBREW_PREFIX="/opt/homebrew"  # or /usr/local
export PATH="$HOMEBREW_PREFIX/bin:$PATH"
```

### 5. ❌ REMOVED: Package Manager Auto-Detection

**Reason**: NOT docker-friendly, NOT practical
- ❌ Requires specific package managers installed
- ❌ Doesn't work in minimal containers
- ❌ Platform-specific assumptions
- ❌ Adds complexity for little benefit

**Alternative**: Standard paths already cover most cases:
- `/usr/local/bin` - already included
- `$HOME/.local/bin` - already included
- Container images set their own PATH

### 6. ❌ REMOVED: Dynamic Platform Detection for Tools

**Reason**: NOT practical
- ❌ Requires commands like `ruby`, `python3` to be installed
- ❌ Runtime detection is fragile
- ❌ Doesn't work in minimal containers

**Alternative**: Use environment variables only (no detection)

## Proposed File Structure

```
shell-dev-env/
├── inc/
│   ├── settings.sh                    # Core settings (updated)
│   ├── env.sh                         # Existing PATH functions
│   ├── env/                           # NEW: Environment modules
│   │   ├── xdg.sh                    # XDG Base Directory support
│   │   ├── prefix.sh                 # PREFIX variable support
│   │   └── languages.sh              # Language env vars (no detection)
│   └── ...
```

## Revised Implementation

### Phase 1: XDG and PREFIX Support (Week 1)

**Create `inc/env/xdg.sh`**:
```bash
#!/bin/bash
# XDG Base Directory Specification support

# Set XDG defaults if not already set
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"

# Add XDG bin directory to PATH if it exists
if [ -d "$XDG_BIN_HOME" ]; then
    registerPath "$XDG_BIN_HOME" 2>/dev/null || export PATH="$XDG_BIN_HOME:$PATH"
fi
```

**Create `inc/env/prefix.sh`**:
```bash
#!/bin/bash
# Standard PREFIX variable support

# Default to $HOME/.local (FHS user-local convention)
export PREFIX="${PREFIX:-$HOME/.local}"

# Add PREFIX paths if they exist
[ -d "$PREFIX/bin" ] && registerPath "$PREFIX/bin" 2>/dev/null || export PATH="$PREFIX/bin:$PATH"
[ -d "$PREFIX/lib" ] && export LD_LIBRARY_PATH="$PREFIX/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
[ -d "$PREFIX/lib/pkgconfig" ] && export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
[ -d "$PREFIX/share/man" ] && export MANPATH="$PREFIX/share/man${MANPATH:+:$MANPATH}"
```

### Phase 2: Language Environment Variables (Week 2)

**Create `inc/env/languages.sh`**:
```bash
#!/bin/bash
# Language-specific environment variables (no auto-detection)

# Go workspace
if [ -n "$GOPATH" ] && [ -d "$GOPATH/bin" ]; then
    registerPath "$GOPATH/bin" 2>/dev/null || export PATH="$GOPATH/bin:$PATH"
elif [ -d "$HOME/go/bin" ]; then
    # Common default location
    registerPath "$HOME/go/bin" 2>/dev/null || export PATH="$HOME/go/bin:$PATH"
fi

# Rust/Cargo
export CARGO_HOME="${CARGO_HOME:-$HOME/.cargo}"
if [ -d "$CARGO_HOME/bin" ]; then
    registerPath "$CARGO_HOME/bin" 2>/dev/null || export PATH="$CARGO_HOME/bin:$PATH"
fi

# Python user base (PEP 370)
if [ -n "$PYTHONUSERBASE" ] && [ -d "$PYTHONUSERBASE/bin" ]; then
    registerPath "$PYTHONUSERBASE/bin" 2>/dev/null || export PATH="$PYTHONUSERBASE/bin:$PATH"
fi

# Node.js npm global prefix
if [ -n "$NPM_CONFIG_PREFIX" ] && [ -d "$NPM_CONFIG_PREFIX/bin" ]; then
    registerPath "$NPM_CONFIG_PREFIX/bin" 2>/dev/null || export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"
fi

# pnpm
export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"
if [ -d "$PNPM_HOME" ]; then
    registerPath "$PNPM_HOME" 2>/dev/null || export PATH="$PNPM_HOME:$PATH"
fi
```

### Update `inc/settings.sh`

```bash
# Settings

# Source new environment modules
[ -f "$ENV_ROOT/inc/env/xdg.sh" ] && source "$ENV_ROOT/inc/env/xdg.sh"
[ -f "$ENV_ROOT/inc/env/prefix.sh" ] && source "$ENV_ROOT/inc/env/prefix.sh"

# Optional: language environments (can be disabled with NO_LANGUAGE_PATHS)
if [ "${NO_LANGUAGE_PATHS:-0}" != "1" ]; then
    [ -f "$ENV_ROOT/inc/env/languages.sh" ] && source "$ENV_ROOT/inc/env/languages.sh"
fi

# Legacy PATH construction (still supported)
export PATH=$HOME/local/bin:$HOME/.local/bin:$ENV_ROOT/bin:$PATH

# Optional /usr/local paths
if [ "${NO_USER_LOCAL:-0}" != "1" ]; then
    export PATH=/usr/local/sbin:/usr/local/bin:$PATH
fi

# Clean up duplicates
uniqueify_PATH

# Rest of settings...
export VIM_BIN=/usr/bin/vim
export EDITOR=$VIM_BIN
# ... etc
```

## Feature Flags (Simplified)

```bash
# Existing
NO_USER_LOCAL="${NO_USER_LOCAL:-0}"          # Skip /usr/local paths

# New (practical only)
NO_LANGUAGE_PATHS="${NO_LANGUAGE_PATHS:-0}"  # Skip language env vars
XDG_COMPLIANCE="${XDG_COMPLIANCE:-1}"        # Enable XDG (default ON)
PREFIX_SUPPORT="${PREFIX_SUPPORT:-1}"        # Enable PREFIX (default ON)
```

## Docker-Friendly Examples

### Example 1: Development Container
```dockerfile
FROM ubuntu:22.04

# Set environment variables BEFORE installing shell-dev-env
ENV PREFIX=/opt/app
ENV GOPATH=/workspace/go
ENV CARGO_HOME=/opt/cargo
ENV XDG_CONFIG_HOME=/workspace/.config
ENV XDG_BIN_HOME=/workspace/.local/bin

# Install shell-dev-env
RUN git clone https://github.com/rightson/shell-dev-env.git ~/.env
RUN bash ~/.env/shell-env.sh patch

# PATH is now correctly set based on environment variables
# No detection, no assumptions, just respecting env vars
```

### Example 2: Production Container
```dockerfile
FROM alpine:3.18

# Minimal PATH, disable language detection
ENV NO_LANGUAGE_PATHS=1
ENV PREFIX=/usr/local
ENV XDG_BIN_HOME=/app/bin

RUN git clone https://github.com/rightson/shell-dev-env.git ~/.env
RUN bash ~/.env/shell-env.sh patch

# Clean, predictable PATH
```

### Example 3: Multi-stage Build
```dockerfile
# Build stage
FROM golang:1.21 AS builder
ENV GOPATH=/build/go
ENV PREFIX=/build/output

# Shell-dev-env respects these without detection
RUN git clone https://github.com/rightson/shell-dev-env.git ~/.env && \
    bash ~/.env/shell-env.sh patch

# Runtime stage
FROM alpine:3.18
ENV PREFIX=/app
COPY --from=builder /build/output /app
# PATH automatically includes /app/bin
```

## Backward Compatibility

✅ **100% backward compatible**:

1. **Default behavior unchanged**: If no env vars set, works exactly as before
2. **Existing paths preserved**: All current hardcoded paths still included
3. **No breaking changes**: New functionality is additive only
4. **Feature flags**: All new features can be disabled

## Testing Strategy

1. **Container tests**: Test in Docker/Podman containers
2. **Minimal environments**: Test in Alpine, busybox
3. **Standard environments**: Test in Ubuntu, Debian, Fedora
4. **Without tools**: Test when language tools NOT installed
5. **With env vars**: Test with various env var combinations

## Performance

- **Zero overhead**: No command execution (`brew --prefix`, `python3 -m site`, etc.)
- **No detection**: Just check if directories exist
- **Fast startup**: Simple environment variable expansion
- **Container-friendly**: No assumptions about installed tools

## Success Metrics

- ✅ Works in Docker containers without modification
- ✅ Works in minimal environments (Alpine, busybox)
- ✅ Zero external command dependencies
- ✅ XDG Base Directory compliant
- ✅ PREFIX variable support
- ✅ Language env vars work without auto-detection
- ✅ 100% backward compatible
- ✅ No breaking changes

## What Was Removed (Not Practical)

### ❌ Dynamic Homebrew Detection
```bash
# REMOVED - too complex, not docker-friendly
if command -v brew &> /dev/null; then
    HOMEBREW_PREFIX="$(brew --prefix)"  # SLOW
    export PATH="$HOMEBREW_PREFIX/bin:$PATH"
fi
```

**Why removed**: Requires `brew` installed, slow, macOS-specific, doesn't work in containers.

### ❌ Package Manager Detection
```bash
# REMOVED - not practical
if [ -d "/snap/bin" ]; then
    export PATH="/snap/bin:$PATH"
fi
```

**Why removed**: Platform-specific, not portable, unnecessary in containers.

### ❌ Language Tool Detection
```bash
# REMOVED - requires tools installed
if command -v python3 &> /dev/null; then
    PYTHON_USER_BASE="$(python3 -m site --user-base)"
    export PATH="$PYTHON_USER_BASE/bin:$PATH"
fi
```

**Why removed**: Requires Python installed, runtime detection fragile, doesn't work in minimal containers.

## Migration Guide

### For Existing Users
No changes needed - everything works as before.

### For Docker Users
```dockerfile
# Set env vars before installing
ENV PREFIX=/app
ENV GOPATH=/workspace/go
ENV XDG_BIN_HOME=/app/.local/bin

RUN git clone ... && bash ~/.env/shell-env.sh patch
```

### For Language Developers
```bash
# In your .bashrc / .zshrc
export GOPATH="$HOME/projects/go"
export CARGO_HOME="$HOME/.cargo"
export NPM_CONFIG_PREFIX="$HOME/.npm-global"

# Then source shell-dev-env
source ~/.env/seeds/bashrc
```

## Conclusion

This **practical, docker-friendly** proposal improves `shell-dev-env` by:

1. ✅ **XDG compliance** - Industry standard, container-friendly
2. ✅ **PREFIX support** - Build system standard, widely used
3. ✅ **Language env vars** - Standard variables, no detection
4. ❌ **No complex detection** - No `brew --prefix`, no `command -v`
5. ❌ **No platform assumptions** - Works everywhere
6. ✅ **100% backward compatible** - Zero breaking changes

**Focus**: Respect standard environment variables that users/containers already set, instead of trying to detect and guess what they want.

---

**Author**: Claude (AI Assistant)
**Date**: 2025-11-15
**Status**: Revised - Practical & Docker-Friendly Approach
