# Bash Scripts

This repository contains bash scripts created to make some of my routine tasks more efficient and improve my bash skills

## Gitstuff

When prompted for actions in these scripts you can type "__quit__" to exit the script - or alternatively just __Ctrl+c__ at any time to stop program

### gitbranch.sh
__interactive menu for checking out local or remote branches__

#### Features
+ checks script invoked from within git working directory
+ choice of either local or remote list of branches to checkout
+ if remote is chosen git fetch is run automatically
+ option to filter remote branches list by matching substring in branch name

#### To Use:
1. Copy the script to somewhere on your $PATH (e.g. cp ./gitbranch.sh ~/local/bin/gitbranch) and make sure it is executable (chmod u+x gitbranch)
2. Go to a folder which is a git working directory and call script  with option -l for local branches or -r for remote branches (e.g. `gitbranch -l`). If neither option is provided the script will prompt the user for an explicit choice or local or remote within the menus.
3. If remote is chosen you have the option to enter a substring of the branch name to filter results by to make the remote list more manageable
4. Enter the number of the branch you want to checkout and the script will use `git checkout` to check it out for you

gitbranch.sh : interactive menu for delet

#### Features
+ checks script invoked from within git working directory
+ choice of either local or remote list of branches to checkout
+ if remote is chosen git fetch is run automatically
+ option to filter remote branches list by matching substring in branch name

#### To Use:
1. Copy the script to somewhere on your $PATH (e.g. `cp ./gitbranch.sh /usr/local/bin/gitbranch`) and make sure it is executable (`chmod u+x gitbranch`)
2. Go to a folder which is a git working directory and call script  with option -l for local branches or -r for remote branches (e.g. `gitbranch -l`). If neither option is provided the script will prompt the user for an explicit choice or local or remote within the menus.
3. If remote is chosen you have the option to enter a substring of the branch name to filter results by to make the remote list more manageable
4. Enter the number of the branch you want to checkout and the script will use `git checkout` to check it out for you

### gitbranchdelete.sh
__interactive menu for deleting local branches__

#### Features
+ checks script invoked from within git working directory
+ select multiple branches for deletion with comma separated list
+ choice of delete with checks or force delete (ie. git branch -d OR -D)
+ validation of branch numbers selected

#### To Use:
1. Copy the script to somewhere on your $PATH (e.g. `cp ./gitbranchdelete.sh /usr/local/bin/gitbranchdelete`) and make sure it is executable (`chmod u+x gitbranchdelete`)
2. Go to a folder which is a git working directory and call script `gitbranchdelete`
3. Enter the number(s) of the branches you want to delete - separated with commas if more than one (e.g. `2,3,5`)
4. Choose whether deleting with checks or force delete (force delete means no checks, whereas otherwise git delete will check if the branch has been fully merged into upstream branch and stop if it hasn't)
