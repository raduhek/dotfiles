# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

export PATH=$PATH:$HOME/bin:/usr/local/go/bin

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=
HISTFILESIZE=
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# Git goodies
_parse_git_dirty() {
    STATUS="$(git status 2> /dev/null)"
    if [[ $? -ne 0 ]]; then
        PS_GIT_DIRTY="-"
        return
    fi
    PS_GIT_STATUS=""
    if echo ${STATUS} | grep -c "renamed:"         &> /dev/null; then PS_GIT_STATUS=">"; fi
    if echo ${STATUS} | grep -c "branch is ahead:" &> /dev/null; then PS_GIT_STATUS="!"; fi
    if echo ${STATUS} | grep -c "new file::"       &> /dev/null; then PS_GIT_STATUS="+"; fi
    if echo ${STATUS} | grep -c "Untracked files:" &> /dev/null; then PS_GIT_STATUS="?"; fi
    if echo ${STATUS} | grep -c "modified:"        &> /dev/null; then PS_GIT_STATUS="*"; fi
    if echo ${STATUS} | grep -c "deleted:"         &> /dev/null; then PS_GIT_STATUS="-"; fi
    PS_GIT_DIRTY="[${PS_GIT_STATUS}]"
}

_parse_git_branch() {
    PS_GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    PS_GIT="${PY}: \${PS_GIT_BRANCH}${PRES}"
    PS_GIT_DIRTY=""
    return
    if [[ ! -z ${PS_GIT_BRANCH} ]]; then
        _parse_git_dirty
    fi
}

_parse_virtualenv() {
    PS_VENV=""
    if [[ ! -z "$VIRTUAL_ENV" ]]; then
        PS_VENV="[`basename \"\$VIRTUAL_ENV\"`] "
    fi
}

_ps1() {
    LAST_EXIT_CODE=$?
    history -a
    PS_GIT=""
    PS_LE="\#:${LAST_EXIT_CODE} "
    if [[ $LAST_EXIT_CODE -ne 0 ]]; then
        PS_LE="${PR}${PS_LE}${PRES} "
    fi
    _parse_virtualenv
    if [[ -d .git ]]; then
        _parse_git_branch
    fi
    PS1="\${debian_chroot:+(\$debian_chroot)}${PS_LE}${PG}\u${PRES}@${PB}\w${PRES}${PS_GIT}\n${PS_VENV}\$ "
}

PROMPT_COMMAND="_ps1"
PRES="\[\033[0m\]"
PR="\[\033[0;31m\]"
PG="\[\033[01;32m\]"
PB="\[\033[01;34m\]"
PY="\[\033[0;33m\]"

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep -i --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

eval `ssh-agent` 2>&1 > /dev/null
ssh-add > /dev/null 2>&1

export ANSIBLE_SSH_ARGS=""
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source /usr/local/bin/virtualenvwrapper.sh

export DOCKER_HOST=tcp://localhost:2375
