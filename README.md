# dotenv

Opinionated dotfiles bootstrapper for bash/zsh/tcsh with Vim/Neovim, tmux, and optional macOS/Windows niceties.

## Highlights
- One command patches your shell rc, tmux, Vim/Neovim configs, and applies git defaults.
- Backups your shell rc before patching and keeps templates in `seeds/` so you can tweak them safely.
- Installs helper tooling for you: `vim-plug`, `tmux-tpm`, and `fzf` (plus helper for `nvm`).
- Curated aliases, prompts, history settings, and utilities live under `inc/` and `bin/`.
- Cross-platform: Linux/macOS shell scripts and a PowerShell profile patcher for Windows.

## Quick start
1) Clone
```bash
git clone https://github.com/rightson/dotenv.git ~/.env
```
2) Patch, install, and configure (default)
```bash
bash ~/.env/dotenv          # patches rc files + installs tools + configures git/vim
```
   - Only patch rc files (no installs): `bash ~/.env/dotenv patch`
   - Only install helper tools: `bash ~/.env/dotenv install`
   - Only apply git/vim defaults: `bash ~/.env/dotenv config`
3) Reload your shell rc  
`source ~/.bashrc` or `source ~/.zshrc` (tcsh uses `~/.cshrc`).

Windows PowerShell:
```powershell
powershell -File $HOME\.env\dotenv.ps1   # patches your PowerShell profile with aliases/prompt
```

## What gets installed or patched
- **Shell rc (bash/zsh/tcsh)**: Adds an `.env` block from `seeds/*rc` with aliases, history, prompt, fzf helpers, and exports `ENV_ROOT`. Shell rc files are backed up with a timestamp before patching.
- **Tmux**: Appends `seeds/tmux.conf` once; includes TPM hooks and sensible defaults.
- **Vim / Neovim**: Sources configs from `vim/` plus local override files (`~/.vimrc.plug`, `~/.config/nvim/extra-plug.vim`) and wires in `vim-plug`.
- **Git defaults**: Sets `vimdiff` as the difftool, `vim` as core editor, and a long-lived credential cache.
- **Tools**: Installs `vim-plug`, `tmux-tpm`, and `fzf` automatically. Helpers for `nvm` and macOS text keybindings are available in `inc/install.sh`.
- **macOS extras**: Seeds for Hammerspoon and Karabiner are copied with backups if files already exist.
- **Windows extras**: PowerShell profile patcher imports git aliases and a prompt from `inc/`.

## Usage
- `bash ~/.env/dotenv patch|install|config|config-git|config-vim`  
  Run targeted steps instead of the full flow.
- `ENV_ROOT` points to the clone; templates live in `seeds/`, and functions live in `inc/`.
- Shell rc patching is idempotent; rerunning will skip already-patched files. For shell rc files, a `*.bak-<timestamp>` backup is created before changes.

## Customize & extend
- Edit the seed files in `seeds/` to change defaults for shells, tmux, Vim/Neovim, Hammerspoon, or Karabiner.
- Add your own Vim/Neovim plugins in `~/.vimrc.plug` or `~/.config/nvim/extra-plug.vim` (these are created for you).
- Drop personal scripts into `bin/` and ensure it is on your `PATH` via the seeded rc files.

Enjoy :)!
