Introduction
===================

`shell-dev-env` is a configurable shell environment framework for Linux/OSX.

It can help developers to configure and organize rc files for Bash, Csh, Zsh, vimrc, screerc, tmux.conf in a simple way.


Installation
===================

Three steps:

1. `git clone https://github.com/rightson/shell-dev-env.git ~/.env`

2.  run the deployment script:

	`bash ~/.shell-dev-env/deploy.sh all`
	
3. source rc file. 

  - bash on Linux: `source ~/.bashrc` 
  - bash on Mac:   `source ~/.bash_profile`
  - tcsh or C shell: `source ~/.cshrc` 
  - zsh: source ~/.zshrc
	

### Tips

The package is relocatable , if you don't like the name `~/.env`, 
you can rename it as you like and then run `deploy.sh relocate` to re-deploy it!

Vundle can be enabled in ~/.vimrc file, but you need to clone a vundle first.


Handy Utilities (old-school)
===================

There'are some useful utilities included in your PATH after installed, you can try to use them happily:

### Cscope Wrapper - cs.sh

cs.sh is a wrapper for Cscope, it can generate cscope.out file in a smart way.

Then just type `cs.sh` from command line then you can see the usage, below is an example:

	cd ~/your_driver_source_dir
	cs.sh add .
	cs.sh add ../your_kernel_source_dir
	
then you could get `cscope.out` file immediately.


### SVN Wrapper - list-svn-diff.sh

If you work with Subversion command line client, list-svn-diff can help you combine the `svn diff` with `vimdiff` in a quick fashion.

In command line, type `s`, list-svn-diff.sh will inspect you code change in subversion working copy. 

    s

If there are some changes in your SVN working copy, you will see some messages like:

    alias s1='svn diff --diff-cmd ~/.shell-dev-env/bin/svn-diff.sh lowlevel_init.S '

Then you can use the alias `s1` to invoke svn diff command which will use `vimdiff` to start your diff process.

### Kermit Wrapper - km.sh

km.sh is a wrapper for `kermit`, it can help people work with kermit without having to type lengthy commands. Just type `km.sh` in your command line then you can understand how to use it.

Enjoy : )

