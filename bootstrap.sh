#!/usr/bin/env bash

set -e

log(){
  echo -e "$(tput setaf 6)> $*$(tput sgr0)"
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

  if [ -e "$destination" ]
  then
    log "$destination already exists"
  else
    log "Copying $source to $destination"
    cp -Rfv "$source" "$destination"
  fi
}

ensure_clone(){
  local source=$1
  local destination=$2

  if [ -e "$destination" ]
  then
    log "$destination already exists"
  else
    log "Cloning $source to $destination"
    git clone "$source" "$destination"
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
ensure_copy ./aliases $HOME/.aliases
ensure_copy ./bash_profile $HOME/.bash_profile
ensure_copy ./bashrc $HOME/.bashrc
ensure_directory $HOME/.config/nvim
ensure_copy ./nvimrc $HOME/.config/nvim/init.vim
ensure_clone https://github.com/VundleVim/Vundle.vim.git $HOME/.config/nvim/bundle/Vundle.vim
ensure_copy ./zshrc $HOME/.zshrc
ensure_copy ./gitconfig $HOME/.gitconfig
ensure_copy ./gitignore $HOME/.gitignore
ensure_copy ./hushlogin $HOME/.hushlogin

header "## Installing oh-my-zsh ##"
if [ -d $HOME/.oh-my-zsh ]
then
  log "oh-my-zsh is already installed. Either remove $HOME/.oh-my-zsh and re-run the bootstrap, or ignore this warning."
else
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

header "## ☯ Install complete ☯ ##"
