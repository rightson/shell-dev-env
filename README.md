Introduction
===================

`shell-dev-env` is a Linux Shell (Bash) development environment sample which provides a simple way to configure and orgnizes the bashrc, vimrc, screerc and other binary in a smart way.

Installation
===================

There are only 3 steps to install this pacakge:

Step 1, get the package - clone the package to your home folder:

	git clone https://github.com/rightson/shell-dev-env.git ~/.shell-dev-env

Step 2, deploy the package - run the deployment script:

	bash ~/.shell-dev-env/deploy.sh	
	
Step 3, use the package - run `source ~/.bashrc` or `source ~/.bash_profile` command.

Enjoy it!	

### Tips

1. You could enable vundle in ~/.vimrc file
2. You could customize your bashrc, vimrc, and screenrc in ~/.shell-dev-env/env/.
3. The deploy.sh will append ~/.shell-dev-env/rc/* to your ~/.bashrc, ~/.vimrc, and ~/.screernc separately.


Handy Utilities
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

