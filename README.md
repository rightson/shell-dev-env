dotenv
===================

*** Breaking changes ***

Please note that dotenv was rewritten entirely.
For those who wants to update to latest version but still using the legacy versions,
please remove legacy patched from existing rc files (~/.bashrc, ~/.zshrc, ~/.vimrc ...) manually.

---

`dotenv` is a all-in-one package for Unix-like shell environment such as Linux and macOS.

It can help developers to configure rc files in a simple but structural way.

Supported RC files:
   - .bashrc (or .bash_profile)
   - .zshrc
   - .vimrc
   - .tmux.conf

Installation
===================

###### 1. Clone source code:
	git clone https://github.com/rightson/dotenv.git ~/.env

###### 2.  Install RC files:

Linux/MacOS:

	bash ~/.env/shell-env.sh

If you don't wnat to install dependencies, just run

	bash ~/.env/shell-env.sh patch

Windows:

	powershell ~\.env\shell-env.ps1

###### 3. source rc file.

Linux/MacOS:

	source $PROFILE_PATH

Windows:

	. $PROFILE

Enjoy : )

