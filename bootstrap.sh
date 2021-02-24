#!/usr/bin/env bash

set -e

log(){
  echo -e "$(tput setaf 6)> $*$(tput sgr0)"
}

warn(){
  echo -e "$(tput setaf 1)> $*$(tput sgr0)"
}

header(){
  content="$*"; printf -v line '%*s' "${#content}";
  echo -e "$(tput bold)$(tput setaf 5)${line// /#}$(tput sgr0)"
  echo -e "$(tput bold)$(tput setaf 5)${content}$(tput sgr0)"
  echo -e "$(tput bold)$(tput setaf 5)${line// /#}$(tput sgr0)"
}

ensure_copy(){
  local source=$1
  local destination=$2

  if [ -h "$destination" ]
  then
    log "$destination already exists"
  else
    log "Copying $source to $destination"
    cp -Rfv "$source" "$destination"
  fi
}

ensure_symlink(){
  local source=$1
  local destination=$2

  if [ -h "$destination" ]
  then
    log "$destination is already symlinked"
  else
    log "Symlinking $source to $destination"
    ln -s "$source" "$destination"
  fi
}

ensure_directory(){
  local dir_path=$1

  if [ -d "$dir_path" ]
  then
    log "$dir_path already exists"
  else
    log "$dir_path does not exist. Creating."
    mkdir -p $dir_path
  fi
}

header "## Setting up config files ##"

# Config files
ensure_copy ./.aliases ~/.aliases
ensure_copy ./.bash_profile ~/.bash_profile
ensure_copy ./.bashrc ~/.bashrc
ensure_directory ~/.config/nvim
ensure_copy ./.nvimrc ~/.config/nvim/init.vim
ensure_copy ./.zshrc ~/.zshrc
ensure_copy ./.gitconfig ~/.gitconfig
ensure_copy ./.gitignore ~/.gitignore
ensure_copy ./.hushlogin ~/.hushlogin

header "## ☯ Install complete ☯ ##"
