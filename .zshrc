# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Path to your oh-my-zsh installation.
ZSH=/usr/share/oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="eastwood"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

ZSH_TMUX_AUTOSTART=false

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git gitfast vi-mode docker history-substring-search wd tmux fasd colored-man-pages copyfile)

ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source $ZSH/oh-my-zsh.sh

# User configuration
unsetopt nomatch

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Aliases
alias zshconfig="nvim ~/.zshrc"
alias zshreload="source ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias xc='xclip -f -selection clipboard'
alias docker-pid="docker inspect --format '{{ .State.Pid }}'"
alias docker-ip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
alias z="fasd_cd -d"
alias zz="fasd_cd -d -i"
alias c='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

bindkey -M viins '^F' history-incremental-pattern-search-forward
bindkey -M vicmd v edit-command-line
bindkey '^X^A' fasd-complete    # C-x C-a to do fasd-complete (files and directories)
bindkey '^X^F' fasd-complete-f  # C-x C-f to do fasd-complete-f (only files)
bindkey '^X^D' fasd-complete-d  # C-x C-d to do fasd-complete-d (only directories)

texec () {
        local cmd=${2:-bash}
        docker exec -it $1 bash -c "stty cols $COLUMNS rows $LINES && $cmd"
}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/thomas/google-cloud-sdk/path.zsh.inc' ]; then . '/home/thomas/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/thomas/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/thomas/google-cloud-sdk/completion.zsh.inc'; fi

export JIRA_URL='https://jira.omikron.net/browse/'
function jira(){
  xdg-open $JIRA_URL`task _get "$1".jira`
}

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

unsetopt sharehistory

unalias gcl
function gcl() {
  local branch
  branch=$(git branch |
    grep --invert-match '\*' |
    cut -c 3- |
    fzf --ansi --multi --preview="git lob --color=always -50 {}" --preview-window=top:wrap)
  git checkout $branch
}

function gcr() {
  local branch
  branch=$(git branch --all |
    grep --invert-match '\*' |
    cut -c 3- |
    fzf --ansi --multi --preview="git lob --color=always -50 {}" --preview-window=top:wrap)
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

unalias ls
alias ls="exa -la"

function delete-branches() {
    git branch |
        grep --invert-match '\*' |
        cut -c 3- |
        fzf --ansi --multi --preview="git log --color=always -50 {} --" |
        xargs --no-run-if-empty git branch --delete --force
}

function pacman-delete() {
    pacman -Qqte |
        fzf --ansi --multi --preview "pacman -Qi {}" |
        sudo pacman -Rs -
}

function setup-itest() {
    local srcdir=$HOME/src/master
    local project
    project=$(cd $srcdir/itests &&
        fd --maxdepth 1 --type d . |
        grep -v -e src -e custom-classes |
        fzf
    )

    rsync -Pav --delete $srcdir/itests/default/src/test/resources/ffresources/ $srcdir/resources/ffitest/
    rsync -Pav $srcdir/itests/$project/src/test/resources/ffresources/ $srcdir/resources/ffitest/
    ln -snf ffitest $srcdir/resources/fact-finder
}

# This script was automatically generated by the broot program
# More information can be found in https://github.com/Canop/broot
# This function starts broot and executes the command
# it produces, if any.
# It's needed because some shell commands, like `cd`,
# have no useful effect if executed in a subshell.
function br {
    local cmd cmd_file code
    cmd_file=$(mktemp)
    if broot --outcmd "$cmd_file" "$@"; then
        cmd=$(<"$cmd_file")
        rm -f "$cmd_file"
        eval "$cmd"
    else
        code=$?
        rm -f "$cmd_file"
        return "$code"
    fi
}
