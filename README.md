Introduction
===================

Welcome to enjoy and modify the Linux Shell Preset Configuration!

Shell Development Configuration
===================

### Steps

1. Just clone the package

	git clone https://github.com/rightson/shell-dev-env.git ~/.shell-dev-env

2. Start to deploy the environment

	cd ~/.shell-dev-env
	bash deploy.sh

3. Enjoy it!	


### About cs.sh

cs.sh is a wrapper for Cscope, it can generate cscope.out file in a quick way, it is put in `shell-dev-env/bin` folder.
	
	chmod +x ~/.shell-dev-env/bin/*

Just create soft link in your binary folder in PATH, such as ~/bin or /usr/local/bin, for example:

	ln -s ~/.shell-dev-env/bin/cs.sh /usr/local/bin/	

Then just type `cs.sh` from command line, then you can see the usage.

##### Tips

If you need to create multiple index (ex: index for device drivers and kernel source code), you could achieve this by repeatly running `cs add <dir>` command in your working directory, the cscope.out file works well in this case. For example,

	cd ~/your_driver_source_dir
	cs.sh add .
	cs.sh add ../your_kernel_source_dir
	
then you could get `cscope.out` file immediately.

Happy Coding~


### Magic svn command wrapper

If you have to work with Subversion command line client and you are also a VIMer, you can try to use my svn solution by adding below:

	ln -s ~/.shell-dev-env/bin/svn-diff.sh /usr/local/bin/
	ln -s ~/.shell-dev-env/bin/list-svn-diff.sh /usr/local/bin/

After that, source your bashrc file again (you can run `so` in console if you had `source` *aliases.bashrc* already), then, run `s` in your svn working copy folder, you can see the modified file in command line, use `sc` and `sr` to create and clean special special alias (ex, s1, s2, s3) for checking the svn diff result via vimdiff immediately.


Enjoy : )

