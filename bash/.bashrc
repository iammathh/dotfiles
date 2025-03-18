# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc

PATH=$PATH:$HOME/bin

export PATH


# ----------------------- Environment Variables ----------------------

# Directories
export REPOS="$HOME/Repos"
export GITUSER="iammathh"
export GHREPOS="$REPOS/github.com/$GITUSER"
export DOTFILES="$GHREPOS/dotfiles"
export LAB="$GHREPOS/sandbox"

# System
export USER_ID=$(id -u)

# ------------------------------ Aliases -----------------------------

# ls
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -lathr'

# kubectl
alias k='kubectl'
source <(kubectl completion bash)
complete -o default -F __start_kubectl k
alias kga='kubectl get all'
alias kgs='kubectl get svc'
alias kgn='kubectl get nodes'
alias kgc='kubectl get configmaps'
alias kgs='kubectl get secrets'
alias kgi='kubectl get ingress'
alias kgsa='kubectl get sa'
alias kgr='kubectl get roles'
alias kgp='kubectl get pods'
alias kc='kubectx'
alias kn='kubens'

alias kcs='kubectl config use-context admin@homelab-staging'
alias kcp='kubectl config use-context admin@homelab-production'

# terraform
alias tf='terraform'
alias tp='terraform plan'

# git
alias gp='git pull'
alias gs='git status'

# others
alias t='tmux'
alias e='exit'
alias c='clear'
alias v='vim' 

# finds all files recursively and sorts by last modification, ignore hidden files
alias lastmod='find . -type f -not -path "*/\.*" -exec ls -lrt {} +'

# Use fp to do a fzf search and preview the files
alias fp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"

# Search for a file with fzf and open it in vim
alias vf='v $(fp)'

# Repos
alias lab='cd $LAB'
alias dot='cd $GHREPOS/dotfiles'
alias repos='cd $REPOS'
alias ghrepos='cd $GHREPOS'
alias learn='cd $REPOS/github.com/$GITUSER/sandbox/'
alias shp='cd $REPOS/github.com/$GITUSER/selhosted-private/'
alias shps='cd $REPOS/github.com/$GITUSER/selfhosted-private-staging/'
alias shpp='cd $REPOS/github.com/$GITUSER/selfhosted-private-production/'

#
alias asc='scrcpy -m1024 --max-fps=60 --no-audio -K > /dev/null 2>&1 &'

# ------------------------------ Ssh-Agent ---------------------------

# Add ssh keys to ssh-agent ( with fzf selection )
ss () {

  mkdir -p /tmp/.ssh-agent
  # Automatic start ssh-agent and kill on shell exit
  function cleanup {
    TTY=$(basename $(tty))
        if [ -f /tmp/.ssh-agent/ssh-agent-stdout.${TTY} ]; then
      ssh_agent_pid=$(awk '{ print $3 }' /tmp/.ssh-agent/ssh-agent-stdout.${TTY})
      kill -HUP "$ssh_agent_pid"
      rm -f /tmp/.ssh-agent/ssh-agent-stdout.${TTY}
    fi
  }
  trap cleanup EXIT
  TTY=$(basename $(tty))
  eval $(ssh-agent) > /tmp/.ssh-agent/ssh-agent-stdout.${TTY}

  # Add ssh keys of option to ssh-agent using fzf
  local key
  key=$(find ~/.ssh -type f -name "*id*" ! -name "*.pub" | fzf)
  ssh-add $key
}

# Connect to SSH servers ( with fzf selection )
s () {
  local server
  server=$(grep -E '^Host ' ~/.ssh/config | awk '{print $2}' | fzf)
  if [[ -n $server ]]; then
    ssh $server
  fi
}

# ------------------------------ Eval ------------------------------

eval "$(fzf --bash)"
eval "$(direnv hook bash)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# ------------------------------ Bash  -----------------------------

# Theme for bash prompt
export PS1="\[\033[95m\]\u@\h \[\033[32m\]\W\[\033[33m\] [\$(git symbolic-ref --short HEAD 2>/dev/null)]\[\033[00m\]\$ "

# Keep bash eternal history
export HISTTIMEFORMAT="%h/%d/%y - %H:%M:%S "
export HISTCONTROL=ignoreeof
export HISTSIZE=5000
shopt -s histappend
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ; }"'echo $$ $USER "$(history 1)" >> ~/.bash_history_eternal'
 
# Source private rc file
if [ -f $HOME/.bashrc_private ]; then
	. $HOME/.bashrc_private
fi

# ------------------------------ Functions -----------------------------

# Reload bashrc file
reload() {
  source ~/.bashrc
}





