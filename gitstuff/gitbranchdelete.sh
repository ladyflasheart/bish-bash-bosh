#!/usr/local/bin/bash

# make sure in git working tree
in_git_repo=$(git rev-parse --is-inside-work-tree)

if [ "$in_git_repo" != true ]; then
  echo 'This script only works from git repository!'
  exit
fi

# get list of local branches
branches=$(git branch -l)

if [ ! "${branches}" ]; then
  echo "Sorry, no branches found! Quitting now..."
  exit
fi

readarray -t branchlist <<<"$branches"
branchlist_length="${#branchlist[@]}"

for index in "${!branchlist[@]}"; do
  # remove current branch from the choices (marked with * at start of git branch output)
  [[ "${branchlist[$index]}" =~ ^\* ]] && unset 'branchlist[$index]'
  branchname="${branchlist[$index]}"
  [ -z "$branchname" ] && continue
  # remove leading/trailing whitespace from branchname
  branchname=${branchname//[[:space:]]/}
  branchlist[$index]="${branchname}"
done

# list the local branches (not including current branch as can't delete that)
echo "Available local branches...."
for index in "${!branchlist[@]}"; do
  echo "${index} ${branchlist[index]}"
done

read -rp "Enter comma separated list of numbers for branches to DELETE:" branches_to_delete

if [ -z "${branches_to_delete}" ]; then
  echo "No branches chosen. Quitting now..."
  exit
fi

readarray -td ',' numbers <<<"$branches_to_delete"

for choice in "${numbers[@]}"; do
  choice="${choice//[[:space:]]/}"
  if ! [[ "$choice" =~ ^[0-9]+$ ]] || [[ "$choice" -lt 1 ]] || [[ "$choice" -gt "$branchlist_length" ]]; then
    echo "Invalid choice $choice ...skipping"
    continue
  fi
  branch="${branchlist[$choice]}"
  echo "Choose to delete branch ${branch}:"
  PS3="Choose delete type 1 or 2 for ${branch}:"
  select delete_type in 'only if it has been pushed and merged (-d)' 'with force delete (-D)'; do
    case $REPLY in
    1)
      git branch -d "${branch}"
      break
      ;;
    2)
      git branch -D "${branch}"
      break
      ;;
    *)
      echo 'Please choose either option 1 or 2'
      ;;
    esac
  done
done
