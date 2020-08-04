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

for index in "${!branchlist[@]}"; do
  # remove current branch from the choices (marked with * at start of git branch output)
  [[ "${branchlist[$index]}" =~ ^\* ]] && unset 'branchlist[$index]'
  branchname="${branchlist[$index]}"
  [ -z "$branchname" ] && continue
  # remove leading/trailing whitespace from branchname
  branchname=${branchname//[[:space:]]/}
  branchlist[$index]="${branchname}"
done

branchlist_length="${#branchlist[@]}"
if [ "${branchlist_length}" -eq 0 ]; then
  echo "Sorry, no branches found! Quitting now..."
  exit
fi

# renumber the array with sequential choices starting at 1
declare -a renumbered_branchlist
choice_number=1
for index in "${!branchlist[@]}"; do
  if [ "${#renumbered_branchlist[@]}" -eq 0 ]; then
    renumbered_branchlist[$choice_number]=${branchlist[index]}
  else
    renumbered_branchlist+=(${branchlist[$index]})
  fi
done

renumbered_branchlist_length="${#renumbered_branchlist[@]}"

# list the local branches (not including current branch as can't delete that)
echo "Available local branches...."

for index in "${!renumbered_branchlist[@]}"; do
  echo "${index} ${renumbered_branchlist[index]}"
done

read -rp 'Enter comma separated list of numbers for branches to DELETE - or else type "quit":' branches_to_delete
if [ "${branches_to_delete}" = 'quit' ]; then
    echo 'Quitting now...'
    exit
fi

if [ -z "${branches_to_delete}" ]; then
  echo "No branches chosen. Quitting now..."
  exit
fi

# decide between force delete -D or with check -d
echo "Choose force delete..."
PS3='Do you want to FORCE DELETE -D the branches?'
COLUMNS=1
select setting in 'yes' 'no'; do
  case $REPLY in
  1)
    force=true
    break
    ;;
  2)
    force=false
    break
    ;;
  'quit')
    echo "Quitting now..."
    exit
    break
    ;;
  *)
    echo 'Please choose either option 1 or 2 - or else type "quit"'
    ;;
  esac
done

readarray -td ',' numbers <<<"$branches_to_delete"

for choice in "${numbers[@]}"; do
  choice="${choice//[[:space:]]/}"
  if ! [[ "$choice" =~ ^[0-9]+$ ]] || [[ "$choice" -lt 1 ]] || [[ "$choice" -gt "$renumbered_branchlist_length" ]]; then
    echo "Invalid choice $choice ...skipping"
    continue
  fi
  branch="${renumbered_branchlist[$choice]}"
  echo "Deleting branch ${branch}"
  if [ "$force" = true ]; then
      git branch -D "${branch}"
  else
      git branch -d "${branch}"
  fi
done
