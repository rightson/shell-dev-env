# Proposal: Improve PATH Defaults Using Standard Environment Variables

## Executive Summary

This proposal outlines improvements to `shell-dev-env`'s PATH and environment variable management by leveraging standard default environment variables from various ecosystems. This will make the configuration more portable, standards-compliant, and user-friendly.

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
1. **Hardcoded paths** - Does not respect user's custom installation prefixes
2. **No XDG compliance** - Does not follow XDG Base Directory specification
3. **Missing language ecosystems** - No support for Go, Rust, Node.js, Ruby, etc.
4. **Platform-specific paths hardcoded** - Homebrew paths not dynamically detected
5. **Limited customization** - Only `NO_USER_LOCAL` flag available
6. **No modern package manager support** - Missing snap, flatpak, appimage paths

## Proposed Improvements

### 1. XDG Base Directory Specification Support

**Rationale**: The XDG Base Directory specification is a well-established standard for organizing user files on Unix-like systems.

**Implementation**:
```bash
# Set XDG defaults if not already set
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"

# Add XDG bin directory to PATH
export PATH="$XDG_BIN_HOME:$PATH"
```

**Benefits**:
- Standards-compliant
- Users can customize locations via environment variables
- Better organization of user files

### 2. Dynamic Homebrew Detection (macOS/Linux)

**Rationale**: Homebrew can be installed in different locations (Intel Mac: `/usr/local`, Apple Silicon: `/opt/homebrew`, Linux: `/home/linuxbrew/.linuxbrew`).

**Implementation**:
```bash
# Detect Homebrew prefix dynamically
if command -v brew &> /dev/null; then
    HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix)}"
    export HOMEBREW_PREFIX
    export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"

    # Add Homebrew-specific environment variables
    export HOMEBREW_CELLAR="${HOMEBREW_CELLAR:-$HOMEBREW_PREFIX/Cellar}"
    export HOMEBREW_REPOSITORY="${HOMEBREW_REPOSITORY:-$HOMEBREW_PREFIX}"
fi
```

**Benefits**:
- Works across Intel and Apple Silicon Macs
- Supports Linux Homebrew installations
- Respects custom Homebrew installations

### 3. Language-Specific Environment Variables

#### Go (Golang)
```bash
# Go environment
if command -v go &> /dev/null; then
    export GOPATH="${GOPATH:-$HOME/go}"
    export GOBIN="${GOBIN:-$GOPATH/bin}"
    export PATH="$GOBIN:$PATH"
fi
```

#### Rust
```bash
# Rust/Cargo environment
export CARGO_HOME="${CARGO_HOME:-$HOME/.cargo}"
export RUSTUP_HOME="${RUSTUP_HOME:-$HOME/.rustup}"
if [ -d "$CARGO_HOME/bin" ]; then
    export PATH="$CARGO_HOME/bin:$PATH"
fi
```

#### Node.js / npm
```bash
# Node.js global packages
export NPM_CONFIG_PREFIX="${NPM_CONFIG_PREFIX:-$HOME/.npm-global}"
if [ -d "$NPM_CONFIG_PREFIX/bin" ]; then
    export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"
fi

# pnpm
export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"
if [ -d "$PNPM_HOME" ]; then
    export PATH="$PNPM_HOME:$PATH"
fi
```

#### Python
```bash
# Python user site packages
if command -v python3 &> /dev/null; then
    PYTHON_USER_BASE="${PYTHON_USER_BASE:-$(python3 -m site --user-base)}"
    export PATH="$PYTHON_USER_BASE/bin:$PATH"
fi

# Poetry
export POETRY_HOME="${POETRY_HOME:-$HOME/.local/share/poetry}"
if [ -d "$POETRY_HOME/bin" ]; then
    export PATH="$POETRY_HOME/bin:$PATH"
fi
```

#### Ruby
```bash
# Ruby Gems
if command -v ruby &> /dev/null && command -v gem &> /dev/null; then
    RUBY_GEM_HOME="${GEM_HOME:-$(ruby -e 'puts Gem.user_dir')}"
    export PATH="$RUBY_GEM_HOME/bin:$PATH"
fi
```

### 4. Custom Installation Prefix Support

**Rationale**: Users may want to install software in custom locations using `PREFIX`.

**Implementation**:
```bash
# Custom installation prefix
export PREFIX="${PREFIX:-$HOME/.local}"
export PATH="$PREFIX/bin:$PATH"
export LD_LIBRARY_PATH="$PREFIX/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH"
export MANPATH="$PREFIX/share/man:$MANPATH"
```

### 5. Modern Package Manager Support

```bash
# Snap packages
if [ -d "/snap/bin" ]; then
    export PATH="/snap/bin:$PATH"
fi

# Flatpak
if [ -d "$HOME/.local/share/flatpak/exports/bin" ]; then
    export PATH="$HOME/.local/share/flatpak/exports/bin:$PATH"
fi

if [ -d "/var/lib/flatpak/exports/bin" ]; then
    export PATH="/var/lib/flatpak/exports/bin:$PATH"
fi

# AppImage directory
if [ -d "$HOME/.local/bin/appimages" ]; then
    export PATH="$HOME/.local/bin/appimages:$PATH"
fi

# Nix package manager
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    source "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi
```

### 6. Enhanced Feature Flags

Add more granular control flags:

```bash
# Feature flags (set to 1 to disable)
NO_USER_LOCAL="${NO_USER_LOCAL:-0}"          # Existing flag
NO_HOMEBREW="${NO_HOMEBREW:-0}"              # Skip Homebrew paths
NO_LANGUAGE_PATHS="${NO_LANGUAGE_PATHS:-0}"  # Skip language-specific paths
NO_PKG_MANAGERS="${NO_PKG_MANAGERS:-0}"      # Skip snap/flatpak/etc
USE_MINIMAL_PATH="${USE_MINIMAL_PATH:-0}"    # Only essential paths
```

### 7. Platform-Specific Optimizations

```bash
# Detect platform
PLATFORM="$(uname -s)"

case "$PLATFORM" in
    Darwin)
        # macOS-specific paths
        export PATH="/usr/local/MacGPG2/bin:$PATH"  # GPG Suite
        export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

        # Homebrew (if not already added)
        if [ "$NO_HOMEBREW" != "1" ] && [ -z "$HOMEBREW_PREFIX" ]; then
            if [ -f "/opt/homebrew/bin/brew" ]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            elif [ -f "/usr/local/bin/brew" ]; then
                eval "$(/usr/local/bin/brew shellenv)"
            fi
        fi
        ;;
    Linux)
        # Linux-specific paths
        export PATH="/usr/sbin:$PATH"

        # Add user systemd binaries
        if [ -d "$HOME/.local/lib/systemd/user" ]; then
            export PATH="$HOME/.local/lib/systemd/user:$PATH"
        fi
        ;;
esac
```

## Proposed File Structure

```
shell-dev-env/
├── inc/
│   ├── settings.sh                    # Core settings (simplified)
│   ├── env.sh                         # Existing PATH functions
│   ├── env/                           # NEW: Environment modules
│   │   ├── xdg.sh                    # XDG Base Directory support
│   │   ├── homebrew.sh               # Homebrew detection
│   │   ├── languages.sh              # Language-specific environments
│   │   ├── package-managers.sh       # Snap, Flatpak, Nix support
│   │   └── platform.sh               # Platform-specific paths
│   └── ...
└── docs/
    ├── PROPOSAL.md                    # This document
    ├── PATH_MANAGEMENT.md             # PATH management guide
    ├── FEATURES.md                    # Feature overview
    └── ENVIRONMENT_VARIABLES.md       # Env var reference
```

## Implementation Plan

### Phase 1: Foundation (Week 1)
1. Create `inc/env/` directory structure
2. Implement XDG Base Directory support (`inc/env/xdg.sh`)
3. Add feature flags to control new behaviors
4. Update `inc/settings.sh` to source new modules
5. Comprehensive testing on Linux and macOS

### Phase 2: Language Support (Week 2)
1. Implement language-specific environment detection (`inc/env/languages.sh`)
2. Add Go, Rust, Node.js, Python, Ruby support
3. Create optional loading mechanism
4. Test with various language installations

### Phase 3: Package Managers (Week 3)
1. Implement modern package manager support (`inc/env/package-managers.sh`)
2. Add Snap, Flatpak, Nix, AppImage support
3. Platform-specific optimizations (`inc/env/platform.sh`)
4. Homebrew dynamic detection (`inc/env/homebrew.sh`)

### Phase 4: Documentation & Testing (Week 4)
1. Create comprehensive documentation in `docs/`
2. Update README.md with new features
3. Add migration guide for existing users
4. Test on various platforms and configurations
5. Create example configurations

## Backward Compatibility

All changes will maintain backward compatibility:

1. **Default behavior unchanged**: If no environment variables are set, behavior matches current implementation
2. **Feature flags**: All new features can be disabled via flags
3. **Opt-in language support**: Language-specific paths only added if tools detected
4. **Graceful degradation**: Missing commands/directories are safely skipped

## Migration Guide for Users

### Existing Users
No action required - current behavior is preserved by default.

### Users Who Want New Features

**Option 1: Enable all features**
```bash
# In your .bashrc/.zshrc before sourcing shell-dev-env
export SHELL_DEV_ENV_ENHANCED=1
```

**Option 2: Selective features**
```bash
# Enable specific features
export XDG_COMPLIANCE=1
export HOMEBREW_AUTO_DETECT=1
export LANGUAGE_ENV_SUPPORT=1
```

**Option 3: Opt-out of specific features**
```bash
# Keep new defaults but disable specific features
export NO_HOMEBREW=1
export NO_LANGUAGE_PATHS=1
```

## Testing Strategy

1. **Unit tests**: Test each environment detection function
2. **Integration tests**: Test full PATH construction
3. **Platform tests**: Test on macOS (Intel/ARM), Ubuntu, Debian, Arch, Fedora
4. **Shell tests**: Test on bash, zsh, tcsh
5. **Edge cases**: Test missing commands, custom installations, etc.

## Performance Considerations

- **Lazy evaluation**: Only detect tools when needed
- **Caching**: Cache detected paths in session variables
- **Conditional loading**: Skip checks if feature flags disabled
- **Fast path**: Optimize common cases

## Security Considerations

1. **No automatic command execution**: Only source known-good scripts
2. **Path validation**: Verify directories exist before adding to PATH
3. **No untrusted inputs**: Don't evaluate user-provided strings
4. **Privilege separation**: Don't require or assume root access

## Expected Benefits

1. **Better standards compliance** - XDG, language-specific conventions
2. **Improved portability** - Works across different platforms and setups
3. **Enhanced flexibility** - Users can customize via environment variables
4. **Modern tool support** - Supports contemporary package managers and languages
5. **Maintained simplicity** - Modular design keeps complexity manageable
6. **Zero breaking changes** - Backward compatible with existing installations

## Success Metrics

- ✅ Zero breaking changes for existing users
- ✅ Support for 5+ language ecosystems (Go, Rust, Node, Python, Ruby)
- ✅ Dynamic Homebrew detection on macOS
- ✅ XDG Base Directory compliance
- ✅ Support for 3+ modern package managers (Snap, Flatpak, Nix)
- ✅ Documentation coverage for all new features
- ✅ Tests passing on 3+ platforms

## Conclusion

This proposal modernizes `shell-dev-env`'s PATH management while maintaining backward compatibility. By leveraging standard environment variables and supporting modern development tools, we make the system more flexible, portable, and user-friendly.

The modular approach allows users to opt-in to features they need while keeping the core simple and fast for users who prefer the current behavior.

## Next Steps

1. Review and approve this proposal
2. Create detailed implementation issues
3. Begin Phase 1 implementation
4. Gather community feedback
5. Iterate based on real-world usage

---

**Author**: Claude (AI Assistant)
**Date**: 2025-11-15
**Status**: Draft - Pending Review
