#Bash Scripts

This repository contains bash scripts created to make some of my routine tasks more efficient and improve my bash skills

##Gitstuff
gitbranch.sh : interactive menu for checking out local or remote branches

####Features
+ checks script invoked from within git working directory
+ choice of either local or remote list of branches to checkout
+ if remote is chosen git fetch is run automatically
+ option to filter remote branches list by matching substring in branch name

####To Use:
1. Copy the script to somewhere on your $PATH (e.g. cp ./gitbranch.sh ~/local/bin/gitbranch) and make sure it is executable (chmod u+x gitbranch)
2. Go to a folder which is a git working directory and call script  with option -l for local branches or -r for remote branches (e.g. `gitbranch -l`). If neither option is provided the script will prompt the user for an explicit choice or local or remote within the menus.
3. If remote is chosen you have the option to enter a substring of the branch name to filter results by to make the remote list more manageable
4. Enter the number of the branch you want to checkout and the script will use `git checkout` to check it out for you
