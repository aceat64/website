# Uncomment to profile startup times, be sure to add `zprof` at the end of this file
# zmodload zsh/zprof

eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/acecat.omp.toml)"

export PATH="$HOME/.local/bin:$PATH"

# Needed to let python know where some libs are
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/opt/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH"
export DYLD_LIBRARY_PATH="/usr/local/lib:/opt/homebrew/lib:$DYLD_LIBRARY_PATH"

# NodeJS (nvm)
# When installing nvm you may need to ensure that the ~/.nvm directory exists,
# and that it contains the `nvm.sh` and `bash_completion` files, or symlinks to them.
if [ -s "$HOME/.nvm/nvm.sh" ]; then
  export NVM_DIR="$HOME/.nvm"
  . "$NVM_DIR/nvm.sh" --no-use # This loads nvm, without auto-using the default version
fi

# uv autocompletion
# Uncomment the next line if you get the error: 'command not found: compdef'
autoload -Uz compinit && compinit
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

# bat config
export BAT_THEME="Catppuccin-mocha"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
alias bathelp="bat --plain --language=help"
help() {
  "$@" --help 2>&1 | bathelp
}

# fzf keybindings and fuzzy search
if [ -f ~/.fzf.zsh ]; then
  # On MacOS this file is created by brew
  source ~/.fzf.zsh
elif [ -d "/usr/share/doc/fzf/examples" ]; then
  # We're probably on Ubuntu/Debian, so load the files from here
  source /usr/share/doc/fzf/examples/key-bindings.zsh
  source /usr/share/doc/fzf/examples/completion.zsh
fi
# catppuccin mocha theme for fzf
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# aliases & functions
alias zls="zfs list -o type,name,available,used,logicalused,usedbysnapshots,compressratio,mountpoint"
alias zsl="zfs list -t snapshot"
alias s="ssh -l root"
alias l="ls -la"

# get all kubernetes resources for a namespace
kubectlgetall() {
  if [ -z "$1" ]; then
    echo "Usage: $0 <namespace>"
    return 1
  fi
  for i in $(kubectl api-resources --verbs=list --namespaced -o name | grep -v "events.events.k8s.io" | grep -v "events" | sort | uniq); do
    echo "Resource:" $i
    kubectl -n ${1} get --ignore-not-found ${i}
  done
}

# nextcloud
occ() {
  NEXTCLOUD_POD_NAME=$(kubectl get pod -n cosmoknots -l app.kubernetes.io/name=nextcloud -o jsonpath='{.items[0].metadata.name}')
  kubectl exec -n cosmoknots $NEXTCLOUD_POD_NAME -c nextcloud -i -t -- sudo -u '#33' PHP_MEMORY_LIMIT=512M /var/www/html/occ "$@"
}

# base64 decode that also works with base64url variant (no padding)
b64d() {
  local data=""
  while IFS= read -r line || [ -n "$line" ]; do
    data+="$line"
  done
  echo "${data}==" | base64 --decode
}
