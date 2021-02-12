# zmodload zsh/zprof
fortune | cowthink

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# autojump (xen0n/autojump-rs)
source /usr/share/autojump/autojump.zsh

# git completions
fpath=(~/.zsh $fpath)



## Options section
# setopt correct                                                  # Auto correct mistakes
setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
# setopt nocaseglob                                               # Case insensitive globbing
setopt rcexpandparam                                            # Array expension with parameters
# setopt nocheckjobs                                              # Don't warn about running processes when exiting
setopt numericglobsort                                          # Sort filenames numerically when it makes sense
setopt nobeep                                                   # No beep
setopt appendhistory                                            # Immediately append history instead of overwriting
setopt histignorealldups                                        # If a new command is a duplicate, remove the older one
setopt autocd                                                   # if only directory path is entered, cd there.
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt nomatch
setopt globdots # GLOBDOTS lets files beginning with a . be matched without explicitly specifying the dot.


# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST 
# do not store duplications
setopt HIST_IGNORE_DUPS
#ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS
HISTFILE=~/.zhistory

HISTSIZE=3000 # number loaded into memory
SAVEHIST=7500 # number saved

export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim

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

# I'm not 100% sure what this does right now or where it's from we'll roll with it!
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
alias vimnorc="nvim -u NONE"
alias ll="ls -all --color=auto -h "
alias ls="ls --color=auto"
alias spotify="spotify --force-device-scale-factor=2"
alias icat="kitty +kitten icat"
alias klipboard="kitty +kitten clipboard"
alias kssh="kitty +kitten ssh"
alias cp="cp -i"                                                # Confirm before overwriting something
alias mv="mv -i"                                                # Confirm before overwrite
alias df='df -h'                                                # Human-readable sizes
alias free='free -m'                                            # Show sizes in MB
alias du='du --block-size=MiB --human-readable --apparent-size'
alias lg='lazygit'
alias gitu='git add --all && git commit && git push'
alias gitdeployall="git remote | xargs -L1 git push --all"
alias yayclean="yay -Qtdq | yay -Rns -" 
alias t="trash"
alias fzfp="fzf --preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'"
alias qemu='qemu-system-x86_64'
alias grep='grep --color'
alias kc='kdeconnect-cli'
alias open='xdg-open'
alias ra='ranger'

##################
# My Aliases END
##################

###############
#My commands
############

function kittycolor(){
  kitty @set-colors $(fd . '/home/ihasdapie/.config/kitty/kitty-themes/themes/' | fzf)
}

##################
# My Path Exports
##################
export PATH=$PATH:/home/ihasdapie/Applications/
export PATH=$PATH:/home/ihasdapie/.gem/ruby/2.7.0/bin/
export PATH=$PATH:/home/ihasdapie/.cargo/bin/
export PATH=$PATH:/usr/local/i386elfgcc/bin/
export PATH=$PATH:/home/ihasdapie/Scripts/exec/
export PATH=$PATH:/home/ihasdapie/Scripts/exec/
export PATH=$PATH:/home/ihasdapie/go/bin/
export PATH=$PATH:/home/ihasdapie/.poetry/bin/
#######  nnn
export NNN_PLUG="p:preview-tui;j:autojump;f:fzopen;k:kdeconnect" # I should add more!
export NNN_FIFO=/tmp/nnn.fifo
export NNN_COLORS="2136" 
export NNN_OPTS="deH"
export NNN_FCOLORS='c1e2272e006033f7c6d6abc4'
export NNN_TRASH=1 

# return to nnn when done
[ -n "$NNNLVL" ] && PS1="N$NNNLVL $PS1"
# cd on quit
nn ()
{
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



#### FZF
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh
export FZF_DEFAULT_OPTS='--height 69% --layout=reverse --border'
export FZF_DEFAULT_COMMAND='fd --type f --follow --exclude .git'

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
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=*' '' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' squeeze-slashes true
zstyle :compinstall filename '/home/ihasdapie/.zshrc'

autoload -U colors compinit zcalc
colors # Put standard ANSI color codes in shell parameters for easy use.
compinit -d

# End of lines added by compinstall
### Kitty

# # blur kitty
# if [[ $(ps --no-header -p $PPID -o comm) == 'kitty' ]]; then
#         for wid in $(xdotool search --pid $PPID); do
#             xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id $wid; done
# fi 


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

# ROS
rosup () {
  source /opt/ros/noetic/local_setup.zsh
}


# run ls on cd
cd() { builtin cd "$@" && ls; }

# i dont want to type out curl syntax all the time
# so a function to upload something to 0x0.st

upload_0x0 () {
  curl -F "file=@$1" http://0x0.st
}


# Plugins
antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh
source ~/.zsh_plugins.sh


# zprof





