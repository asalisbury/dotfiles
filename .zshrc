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
export EDITOR=nvim
export GIT_EDITOR=nvim

# Use FZF if it's around
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh