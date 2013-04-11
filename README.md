Shell Development Configuration
===================

This package is for developers who are lazy to configure their bash shell environment across different OS distributions again again and again.

cs.sh is a script that wraps dirty flow when creating index for cscope.

Steps for setting Shell
============

### Set up bashrc, vimrc and screenrc

Go to your development directory first, for example:

	cd ~/Developer 

Then clone this package

	git clone https://github.com/rightson/shell-dev-env.git

Create soft link to the env folder, here my folder is named `.my-env` in ~:

	ln -s ~/Developer/shell-dev-env/env ~/.my-env

Append below code to ~/.bash_profile (or ~/.bashrc in Linux)
 
	source ~/.my-env/statusbar.bashrc
	source ~/.my-env/aliases.bashrc 
	source ~/.my-env/bashrc

Then, run

	source ~/.bashrc
	
and you can enjoy it!
	
If you are interested in my custom VIM settings, try to append below code to ~/.vimrc

	source ~/.my-env/vundle.bashrc  # if you use vundle  
	source ~/.my-env/hotkeys.bashrc
	source ~/.my-env/vimrc

My screenrc are can also be included in your ~/.screenrc:

	source ~/.my-env/statusbar.screenrc


### About cs.sh

cs.sh is put in `shell-dev-env/bin` folder, remember to change mode to use it:

	chmod +x ~/Developer/shell-dev-env/bin/*

Just create soft link in your binary folder in PATH, such as ~/bin or /usr/local/bin, for example:

	ln -s ~/Developer/shell-dev-env/bin/cs.sh /user/local/bin/	
Then just type `cs.sh` from command line, then you can see the usage.

### Magic svn command wrapper

If you have to work with Subversion command line client and you are also a VIMer, you can try to use my svn solution by adding below:

	ln -s ~/Developer/shell-dev-env/bin/svn-diff.sh /user/local/bin/
	ln -s ~/Developer/shell-dev-env/bin/list-svn-diff.sh /user/local/bin/

After that, source your bashrc file again (run `so` if you had already source above bashrc), then, run `s` in your svn working copy folder, you can see the modified file in command line, use `sc` and `sr` to create and clean special special alias (ex, s1, s2, s3) for checking the svn diff result via vimdiff immediately.


Enjoy : )