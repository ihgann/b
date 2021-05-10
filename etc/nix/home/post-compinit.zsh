autoload -Uz promptinit
promptinit
# zsh-mime-setup
autoload colors
colors
autoload -Uz zmv # move function
autoload -Uz zed # edit functions within zle
zle_highlight=(isearch:underline)

# Enable ..<TAB> -> ../
zstyle ':completion:*' special-dirs true

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,comm'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

typeset WORDCHARS="*?_-.~[]=&;!#$%^(){}<>"

zle-dev-open-pr() /opt/dev/bin/dev open pr
zle -N zle-dev-open-pr
bindkey 'ø' zle-dev-open-pr # Alt-O ABC Extended
bindkey 'ʼ' zle-dev-open-pr # Alt-O Canadian English

zle-dev-open-github() /opt/dev/bin/dev open github
zle -N zle-dev-open-github
bindkey '©' zle-dev-open-github # Alt-G ABC Extended & Canadian English

zle-dev-open-shipit() /opt/dev/bin/dev open shipit
zle -N zle-dev-open-shipit
bindkey 'ß' zle-dev-open-shipit # Alt-S ABC Extended & Canadian English

zle-dev-open-app() /opt/dev/bin/dev open app
zle -N zle-dev-open-app
bindkey '®' zle-dev-open-app # Alt-R ABC Extended & Canadian English

zle-dev-cd(){ dev cd ${${(z)BUFFER}}; zle .beginning-of-line; zle .kill-line; zle .accept-line }
zle -N zle-dev-cd
bindkey 'ð' zle-dev-cd # Alt-D ABC Extended
bindkey '∂' zle-dev-cd # Alt-D Canadian English

zle-spin() { LBUFFER+="꩜  " }
zle -N zle-spin
bindkey '¡' zle-spin # Alt-1

zle-dev-cd() {
  dev cd "${${(z)BUFFER}}"
  zle .beginning-of-line
  zle .kill-line
  zle .accept-line
}
zle -N zle-dev-cd
bindkey '∂' zle-dev-cd # Alt-D Canadian English

zle-checkout-branch() {
  local branch
  branch="$(git branch -l | fzf -f "${${(z)BUFFER}}" | awk '{print $1; exit}')" 
  git checkout "${branch}" >/dev/null 2>&1
  zle .beginning-of-line
  zle .kill-line
  zle .accept-line
}
zle -N zle-checkout-branch
bindkey '∫' zle-checkout-branch # Alt-B Canadian English

# Figure out the closure size for a certain package
nix-closure-size() {
  nix-store -q --size $(nix-store -qR $(readlink -e $1) ) \
    | awk '{ a+=$1 } END { print a }' \
    | nix run nixpkgs.coreutils -c numfmt --to=iec-i
}

source ~/.iterm2_shell_integration.zsh

if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then
  source ~/.nix-profile/etc/profile.d/nix.sh
fi

if [[ -n "${SCREENCAST}" ]]; then
  HISTFILE=$(mktemp)
fi

export KUBECONFIG=$HOME/.kube/config

if [ -f /opt/dev/dev.sh ]; then
  source /opt/dev/dev.sh
elif [ -f /run/current-system/sw/bin/dev ]; then
  eval $(dev init)
  eval "$(shadowenv init zsh)"
fi
