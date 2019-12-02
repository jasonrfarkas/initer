#!/bin/bash
# This script is meant to be run once and only once to set up your enviornment
# It works by setting up ssh keys to gitlabs/github cloning the repo of your choice and calling it's begin.sh file which
# should handle your specific organization's setup policies
# It will place the cloned repo as a sibling to this repo
REPO_TO_CLONE="$1"
LOCATION_TO_PASTE_KEYS="$2:-https://github.com/settings/ssh/new"

# Add ssh keys
open_in_browser(){
  URL="$1"
  open -a "Google Chrome" "$URL"
}

confirm_action(){
  action="$1"
  hasnt_confirmed=true;
  while $hasnt_confirmed;
  do
      printf "Please confirm you have $action by typing [yes|y] before we confinue\n"
      read -r -p "" response
      if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
      then
          echo "Thank you for confirming"
          hasnt_confirmed=false
      fi
  done
}

setup_git_credentials(){
  # Location
  git_lab_location="$1"
  # Setup gitlab credentials
  printf "Setting up an ssh key to connect into gitlab"
  # Set up global user info
  hasnt_confirmed=true;
  while $hasnt_confirmed;
  do
    printf "Please  you have $action by typing [yes|y] before we confinue\n"
    read -r -p "" response
    git config --global user.name "$response"
    read -r -p "" email_response
    git config --global user.email "$email_response"
    printf "Please confirm you these credentials are correct"
    git config --global user.name
    git config --global user.email
    read -r -p "" response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
    then
        echo "Thank you for confirming - "
        hasnt_confirmed=false
    fi
  done
  # Setting up a ssh key
  printf "Setting up ssh key"
  ssh-keygen -t ed25519 -C "$email_response"
  print "Coping over the new key to your clipboard"
  pbcopy < ~/.ssh/id_ed25519.pub
  get_ready "open chrome and past the new key then hit 'Add Key'"
  open_in_browser $git_lab_location
  confirm_action "Added key to gitlab"
}

git_clone_and_cd() {
  git clone "$1" && cd "$(basename "$1" .git)"
}

setup_git_credentials $LOCATION_TO_PASTE_KEYS

cd $DIR
git_clone_and_cd REPO_TO_CLONE
./begin.sh

