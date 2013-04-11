Shell Development Configuration
===================

This package is for developers who are lazy to configure their bash shell environment across different OS distributions again again and again.


Steps
============
1. go to your development directory  
	`cd ~/Developer  #`  
2. clone this package  
	`git clone https://github.com/rightson/shell-dev-env.git`  

3. create soft link to the env folder  
	`ln -s ~/Developer/shell-dev-env/env ~/.my-env`
4. append below code to ~/.bash_profile (or ~/.bashrc in Linux):
 
	`source ~/.my-env/statusbar.bashrc`  
	`source ~/.my-env/aliases.bashrc`  
	`source ~/.my-env/bashrc`  
	 
5. append below code to ~/.vimrc

	`source ~/.my-env/vundle.bashrc`  # if you have vundle  
	`source ~/.my-env/hotkeys.bashrc`  
	`source ~/.my-env/vimrc`  

6. append below code to ~/.screenrc

	`source ~/.my-env/statusbar.screenrc`  
	
Enjoy : )