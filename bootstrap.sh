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

ensure_repo(){
  local repo_path=$1
  local repo_url=$2

  ensure_directory $repo_path

  (
    cd "$repo_path"
    if git rev-parse --is-inside-work-tree > /dev/null && [ "$repo_path" =  "$(git rev-parse --show-toplevel)" ]
    then
      log "$repo_path is a already a git repository. Updating."
      git pull origin master
    else
      log "$repo_path isn't a git repository. Creating."
      git clone "$repo_url" "$repo_path"
    fi
  )
}

ensure_formula(){
  if brew list | grep -Fxq $1
  then
    log "$1 is already installed"
  else
    brew install $1
  fi
}

header "## Setting up config files ##"

# Config files
ensure_copy ./.aliases ~/.aliases
ensure_copy ./.bash_profile ~/.bash_profile
ensure_copy ./.bashrc ~/.bashrc
ensure_copy ./.functions ~/.functions
ensure_copy ./.vimrc ~/.vimrc
ensure_directory ~/.config/nvim
ensure_copy ./.nvimrc ~/.config/nvim/init.vim
ensure_copy ./.zshrc ~/.zshrc
ensure_copy ./.gitconfig ~/.gitconfig
ensure_copy ./.gitignore ~/.gitignore
ensure_copy ./.hushlogin ~/.hushlogin

header "## Setting up packages ##"

# Shell
ensure_repo ~/.oh-my-zsh git@github.com:robbyrussell/oh-my-zsh.git
ensure_repo ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting git@github.com:zsh-users/zsh-syntax-highlighting.git

# Pure
ensure_repo ~/.oh-my-zsh/custom/plugins/pure git@github.com:sindresorhus/pure.git
ensure_directory ~/.zfunctions
ensure_symlink "$HOME/.oh-my-zsh/custom/plugins/pure/pure.zsh" "$HOME/.zfunctions/prompt_pure_setup"
ensure_symlink "$HOME/.oh-my-zsh/custom/plugins/pure/async.zsh" "$HOME/.zfunctions/async"

# Vim
ensure_repo ~/.vim/bundle/Vundle.vim git@github.com:VundleVim/Vundle.vim.git

# NeoVim
ensure_repo ~/.config/nvim/bundle/Vundle.vim git@github.com:VundleVim/Vundle.vim.git

# Node
ensure_repo ~/.nvm git@github.com:creationix/nvm.git
source ~/.nvm/install.sh

header "## Homebrew ##"

read -n1 -p "Do you want to install Homebrew? [y,n]" doit
case $doit in
  y|Y) ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" ;;
  n|N) echo " Skipping" ;;
  *) echo " ???" ;;
esac

header "## Installing Homebrew packages ##"

declare -a formulae=(
  ack
  bash-completion
  coreutils
  fzf
  git
  hub
  ripgrep
  tldr
  tig
  tmux
  tree
  wget
)

for i in "${formulae[@]}"; do
  ensure_formula "$i"
done

header "## ☯ Install complete ☯ ##"
