# zmodload zsh/zprof

export PATH=$PATH:/usr/games
paste <(fortune | cowsay -f bunny) <(cal) | column  -s $'\t' -t
# krabby random

# instant prompt causes some rescaling jank...
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh



# autojump (xen0n/autojump-rs)


## Options section
# setopt correct                                                  # Auto correct mistakes
setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
# setopt nocaseglob                                               # Case insensitive globbing
setopt rcexpandparam                                            # Array expension with parameters
# setopt nocheckjobs                                              # Don't warn about running processes when exiting
setopt numericglobsort                                          # Sort filenames numerically when it makes sense
setopt nobeep                                                   # No beep 
setopt histignorealldups                                        # If a new command is a duplicate, remove the older one
setopt autocd                                                   # if only directory path is entered, cd there.
setopt EXTENDED_HISTORY
setopt NO_SHARE_HISTORY       # share history makes for weird behaviour on up when broadcasting
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_SPACE
setopt nomatch
setopt globdots # GLOBDOTS lets files beginning with a . be matched without explicitly specifying the dot.
setopt auto_cd


# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST 
# do not store duplications
setopt HIST_IGNORE_DUPS
#ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS
HISTFILE=~/.zhistory

HISTSIZE=6969 # number loaded into memory
SAVEHIST=20000 # number saved


## Keybindings section
bindkey -e
bindkey '^R' history-incremental-search-backward
bindkey '^[[7~' beginning-of-line                               # Home key
bindkey '^[[H' beginning-of-line                                # Home key
if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line                # [Home] - Go to beginning of line
fi
bindkey '^[[8~' end-of-line                                     # End key
bindkey '^[[F' end-of-line                                     # End key
if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}" end-of-line                       # [End] - Go to end of line
fi
bindkey '^[[2~' overwrite-mode                                  # Insert key
bindkey '^[[3~' delete-char                                     # Delete key
bindkey '^[[C'  forward-char                                    # Right key
bindkey '^[[D'  backward-char                                   # Left key
bindkey '^[[5~' history-beginning-search-backward               # Page up key
bindkey '^[[6~' history-beginning-search-forward                # Page down key

# Navigate words with ctrl+arrow keys
bindkey '^[Oc' forward-word                                     #
bindkey '^[Od' backward-word                                    #
bindkey '^[[1;5D' backward-word                                 #
bindkey '^[[1;5C' forward-word                                  #
bindkey '^H' backward-kill-word                                 # delete previous word with ctrl+backspace
bindkey '^[[Z' undo                                             # Shift+tab undo last action

bindkey '^[^M' self-insert-unmeta                               # alt-enter inserts newline instead of executing command

# enable substitution for prompt
setopt prompt_subst

# Color man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-r

ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_AUTOSUGGEST_USE_ASYNC=1


# sets window and tab titles for termianls
function set-title-precmd() {
  printf "\e]2;%s\a" "${PWD/#$HOME/~}"
}

function set-title-preexec() {
  printf "\e]2;%s\a" "$1"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd set-title-precmd
add-zsh-hook preexec set-title-preexec

##################
# My Aliases START
##################
alias vim="nvim"
alias vimf='vim $(fzf)'
alias vimnorc="nvim -u NONE"
alias min="nvim -u ~/.config/nvim/minimal.vim"
alias ll="ls -alh --color=auto --hyperlink"
alias ls="ls --color=auto --hyperlink"
alias spotify="spotify --force-device-scale-factor=2"
alias icat="kitty +kitten icat"
alias klipboard="kitty +kitten clipboard"
alias ssh="kitty +kitten ssh"
alias cp="cp -i"                                                # Confirm before overwriting something
alias mv="mv -i"                                                # Confirm before overwrite
alias df='df -h'                                                # Human-readable sizes
alias free='free -m'                                            # Show sizes in MB
alias lg='lazygit'
alias gitu='git add --all && git commit && git push'
alias gitpushall="git remote | xargs -L1 git push --all"
alias yayclean="yay -Qtdq | yay -Rns -" 
alias t="trash"
alias fzfp="fzf --preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'"
alias qemu='qemu-system-x86_64'
alias grep='grep --color'
alias kc='kdeconnect-cli'
alias ra='ranger'
alias ha='hunter -i -g kitty'
alias za='zathura'
alias mpv='mpv -hwdec' # enable hardware decoding for mpv
alias less='less'
alias rm='trash'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias py="ipython3"
alias qc='qalc'
alias valgrind='colour-valgrind'
##################
# My Aliases END
##################

###############
#My commands
############


##################
# My Path Exports
##################



#######  NNN
export NNN_PLUG="p:preview-tui;j:autojump;f:fzopen;k:kdeconnect;G:git-changes;g:git-status" # I should add more!
export NNN_FIFO=/tmp/nnn.fifo
export NNN_COLORS="2136" 
export NNN_OPTS="de"
export NNN_FCOLORS='c1e2272e006033f7c6d6abc4'
export NNN_TRASH=1 

# return to nnn when done
[ -n "$NNNLVL" ] && PS1="N$NNNLVL $PS1"
# cd on quit
nn () {
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

xd () {
  cd $(xplr)
}


#### FZF

# create fzf_history if it doesn't exist
[ -f $HOME/dotfiles-private/fzf/fzf_history ] || touch $HOME/dotfiles-private/fzf/fzf_history


export FZF_DEFAULT_OPTS="--height 69% --layout=reverse --border --algo=v1 --ansi --history $HOME/dotfiles-private/fzf/fzf_history" # TODO Test v1, v2?
# export FZF_DEFAULT_COMMAND='fd --type f --follow --exclude .git'
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob=!.git/'


# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

#### DIRENV
eval "$(direnv hook zsh)"

### COMPLETIONS #########
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=*' '' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' squeeze-slashes true
zstyle :compinstall filename "$HOME/.zshrc"

autoload -U colors compinit zcalc
colors # Put standard ANSI color codes in shell parameters for easy use.
compinit -d

# End of lines added by compinstall
### Kitty

# Completion for kitty
_kitty() {
    local src
    # Send all words up to the word the cursor is currently on
    src=$(printf "%s
" "${(@)words[1,$CURRENT]}" | kitty +complete zsh)
    if [[ $? == 0 ]]; then
        eval ${src}
    fi
}
compdef _kitty kitty

# # Plugins
zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins.zsh

# Ensure you have a .zsh_plugins.txt file where you can add plugins.
[[ -f ${zsh_plugins:r}.txt ]] || touch ${zsh_plugins:r}.txt

# Lazy-load antidote.
fpath+=(${ZDOTDIR:-~}/.antidote)
autoload -Uz $fpath[-1]/antidote

# Generate static file in a subshell when .zsh_plugins.txt is updated.
if [[ ! $zsh_plugins -nt ${zsh_plugins:r}.txt ]]; then
  (antidote bundle <${zsh_plugins:r}.txt >|$zsh_plugins)
fi

# Source your static plugins file.
source $zsh_plugins


# # zsh autosuggestions
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20 # max lneght of buffer to auttosugest to
export ZSH_AUTOSUGGEST_HISTORY_IGNORE=" "





# some functions {{{


blur_zathura() {
  for wid in $(xdotool search --pid $(pidof zathura)); do
            xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id $wid; done
}

kittycolor(){
  BASE="$HOME/.config/kitty/kitty-themes/themes"
  PICKED=$(fd . "$BASE" | sed 's/\(.*\)\/\(.*\)\.conf/\2/g' | fzf)
  kitty @set-colors "$BASE/$PICKED.conf"
}

blur_kitty () {
if [[ $(ps --no-header -p $PPID -o comm) == 'kitty' ]]; then
        for wid in $(xdotool search --pid $PPID); do
            xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id $wid; done
fi 
}


upload_0x0 () {
  curl -F "file=@$1" https://0x0.st
}

utias_vpn () {
  openvpn $HOME/aUToronto/aUToronto_VPN/spec.ovpn
}




# }}}






# Pretty =less=
export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
export LESS=' -R '

if [ "$(uname)" = "Darwin" ]; then
    export PATH=$PATH:$HOME/.cargo/bin/
    export PATH=$PATH:$HOME/.poetry/bin/
    eval $(brew shellenv)
    eval "$(/usr/libexec/path_helper)"
    export PATH=$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH
    # pyenv (after brew export to put pyenv shims first)
    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"

    # source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
    alias ll="ls -ialh --color=auto"
    alias ls="gls --color=auto --hyperlink"
    alias du='du -h'
    [ -f $(brew --prefix)/etc/profile.d/autojump.sh ] && . $(brew --prefix)/etc/profile.d/autojump.sh


    # export NVM_DIR="$HOME/.nvm"
    # [ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh" # This loads nvm
    # [ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
    export EDITOR=/opt/homebrew/bin/nvim
    export VISUAL=/opt/homebrew/bin/nvim
    export HOMEBREW_NO_AUTO_UPDATE=1


elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
    export PATH=$PATH:$HOME/Applications/
    export PATH=$PATH:$HOME/.gem/ruby/2.7.0/bin/
    export PATH=$PATH:$HOME/.cargo/bin/
    export PATH=$PATH:/usr/local/i386elfgcc/bin/
    export PATH=$PATH:$HOME/Scripts/exec/
    export PATH=$PATH:$HOME/go/bin/
    export PATH=$PATH:$HOME/.poetry/bin/
    export PATH=$PATH:$HOME/.emacs.d/bin/
    export PATH=$PATH:$HOME/.local/bin
    source /usr/share/autojump/autojump.zsh
    # source /usr/share/fzf/completion.zsh
    # source /usr/share/fzf/key-bindings.zsh
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    alias du='du --human-readable --apparent-size'
    unset NODE_EXTRA_CA_CERTS
    eval $(npm completion zsh)
    [ -z "$NVM_DIR" ] && export NVM_DIR="$HOME/.nvm"
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"



    alias open='xdg-open'
    export EDITOR=/usr/bin/nvim
    export VISUAL=/usr/bin/nvim
fi

eval "$(zoxide init zsh)"



source ~/.zshrc.local





# export QSYS_ROOTDIR="/home/ihasdapie/.cache/yay/quartus-free/pkg/quartus-free-quartus/opt/intelFPGA/21.1/quartus/sopc_builder/bin"

# zprof










[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

autoload -U +X bashcompinit && bashcompinit
