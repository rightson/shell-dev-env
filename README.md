Shell Development Environment
===================

*** Breaking changes ***

Please note that the shell-dev-env was rewritten entirely.
For those who wants to update to latest version but still using the legacy versions,
please remove legacy patched from existing rc files (~/.bashrc, ~/.zshrc, ~/.vimrc ...) manually.

---

`shell-dev-env` is a all-in-one package for Unix-like shell environment such as Linux and macOS.

It can help developers to configure rc files in a simple but structural way.

Supported RC files:
   - .bashrc (or .bash_profile)
   - .zshrc
   - .vimrc
   - .tmux.conf

Installation
===================

###### 1. Clone source code:
	`git clone https://github.com/rightson/shell-dev-env.git ~/.env`

###### 2.  Install RC files:

Linux, MacOS:
	`bash ~/.env/shell-env.sh patch install config`

Windows:
	`powershell ~\.env\shell-env.ps1`

###### 3. source rc file.

Linux, MacOS:
	`source $PROFILE_PATH`

Windows:
	`. $PROFILE`

Enjoy : )

