#!/usr/local/bin/bash

# make sure in git working tree
in_git_repo=$(git rev-parse --is-inside-work-tree)

if [ "$in_git_repo" != true ]
then echo 'This script only works from git repository!'
exit
fi

while getopts lr option
do
case "${option}"
in
l) MODE='local';;
r) MODE='remote';;
esac
done

# if not got -l or -r option from command line then prompt user
if [ -z "${MODE}" ]
then
    # decide between checkout local or remote branch
    PS3='Select types of branches to list...'
    COLUMNS=1
    select setting in 'local branches only' 'remote branches only'
    do
      case $REPLY in
      1)
        MODE='local'
        break
        ;;
      2)
        MODE='remote'
        break
        ;;
      *)
        echo 'Please choose either option 1 or 2'
        ;;
      esac
    done
fi

if [ "${MODE}" = 'local' ]
then
  PS3="Choose LOCAL branch to checkout..."
  branches=$(git branch -l)
elif [ "${MODE}" = 'remote' ]
then
  echo "Getting remote branches..."
  git fetch >/dev/null 2>&1
  read -rp 'Enter optional string literal to filter list by (part of) branch name [unfiltered]:' name_match
  [ -z "$name_match" ] &&  branches=$(git branch -r) || branches=$(git branch -r | grep "$name_match")
  PS3="Choose REMOTE branch to checkout..."
fi

if [ ! "${branches}" ]
then echo "Sorry, no branches found! Quitting now..."
exit
fi

readarray -t branchlist <<<"$branches"

for index in "${!branchlist[@]}"; do
  # remove current branch from the choices (marked with * at start of git branch output)
  [[ "${branchlist[$index]}" =~ ^\* ]] && unset 'branchlist[$index]'
  branchname="${branchlist[$index]}"
  [ -z "$branchname" ] && continue
  # remove whitespace and "origin/" part of remote branchnames
  branchname=${branchname//[[:space:]]/}
  branchname=${branchname/origin\//}
  branchlist[$index]="${branchname}"
done

select branch in "${branchlist[@]}"
do
  echo "Checking out ${branch}..."
  git checkout "${branch}"
  break
done
