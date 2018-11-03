export PATH=""

# Load default PATH
if [ -x /usr/libexec/path_helper ]; then eval "$(/usr/libexec/path_helper -s)"; fi
if [ -f /etc/environment ]; then source /etc/environment; fi

fpath=( "$HOME/.zfunctions" $fpath )

# Pure theme
PURE_GIT_PULL=0
autoload -U promptinit; promptinit
prompt pure

# add /usr/local/sbin
if [[ -d /usr/local/sbin ]]; then
  export PATH=/usr/local/sbin:$PATH
fi

# check for custom bin directory and add to path
if [[ -d ~/bin ]]; then
  export PATH=~/bin:$PATH
fi

# aliases
. ~/.aliases
. ~/.functions

# z-script ("directory jumper")
. ~/bin/z.sh

# Set editor
export EDITOR="nvim"
export GIT_EDITOR="nvim"

# Increase Bash history size. Allow 32³ entries; the default is 500.
export HISTSIZE="32768"
export HISTFILESIZE="${HISTSIZE}"

# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL="ignoreboth"

# Enable persistent REPL history for node
NODE_REPL_HISTORY_FILE=~/.node_history

# Increase node REPL history size from default of 1000
NODE_REPL_HISTORY_SIZE="32768"

# Use FZF if it's around
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# dev
[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh

# `nvm use` automatically in a directory with a .nvmrc file
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
