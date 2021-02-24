export ZSH="/Users/alexandersalisbury/.oh-my-zsh"

# Pure (https://github.com/sindresorhus/pure)
ZSH_THEME=""
fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
prompt pure

source $ZSH/oh-my-zsh.sh

# gnu binaries (`find`, `locate`, `updatedb`, and `xargs`, g-prefixed)
export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"

# aliases
. $HOME/.aliases

# Set editor
export EDITOR="nvim"
export GIT_EDITOR="nvim"

# Increase Bash history size. Allow 32³ entries; the default is 500.
export HISTSIZE="32768"
export HISTFILESIZE="${HISTSIZE}"

# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL="ignoreboth"

# Use FZF if it's around
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

# dev
[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh

if [ -e /Users/alexandersalisbury/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/alexandersalisbury/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# cloudplatform: add Shopify clusters to your local kubernetes config
export KUBECONFIG=${KUBECONFIG:+$KUBECONFIG:}/Users/alexandersalisbury/.kube/config:/Users/alexandersalisbury/.kube/config.shopify.cloudplatform
