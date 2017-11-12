# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"


# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git command-not-found svn colored-man-pages)

source $ZSH/oh-my-zsh.sh

autoload -U promptinit
promptinit

# Customize to your needs...
export PATH=$PATH:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

alias sc=~/lib/screencreate.sh
alias pdf="/usr/bin/okular"
alias vim="vim -p"
alias fucking=sudo
function memgrind() {
    valgrind --tool=memcheck --leak-check=yes --show-reachable=yes --num-callers=20 --track-fds=yes "$@" 2> valgrind.out;
}
function cd() {
    builtin cd "$@" && pwd -P;
}

alias grep="LC_ALL=C grep"

# grep for a phrase (func name) within source directories
alias sgrep="grep -n -i -I -d recurse --exclude=\"*/tags\" --exclude-dir=\"*/.svn\" --color=always"
# Show per-proc mem usage in sorted order
alias used="ps -e -orss=,args= | sort -b -k1,1n | pr -TW$COLUMNS | tail -n 20; free -h"

function highlight() {
    HL_TERM="$1|$"
    shift
    $@ | egrep --color "$HL_TERM"
}

# Pretend to be a TTY even if piping to a file
# See http://stackoverflow.com/questions/32910661/pretend-to-be-a-tty-in-bash-for-any-command
function faketty () { script -qfc "$(printf "%q " "$@")"; }

function perrno() {
    perl -MErrno -e 'my %e= map { Errno->$_()=>$_ } keys(%!); print grep !/unknown error/i, map sprintf("%4d %-12s %s".$/,$_,$e{$_},$!=$_), 0..127'
}

# Make git-svn not run like shit on large repos
__git_files() {
    _wanted files expl 'local files' _files
}

function git_prompt_info() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}${ZSH_THEME_GIT_PROMPT_CLEAN}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

function git_commit_diff() {
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative $1..$2
}

# Purge branches that have been merged and deleted on the server
alias gbpurge='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'

export EDITOR=vim

export PAGER=less

# Welcome message
function welcome_message {
    SYSMSG_BOLD="\e[1;35m"
    SYSMSG="\e[0;35m"
    SYSMSG_END="\e[m"
    echo -e "${SYSMSG_BOLD}Welcome back, Master Roberts${SYSMSG_END}"
    echo -e "${SYSMSG}You have `who | grep "$USER" | wc -l` terminals open${SYSMSG_END}"
}

# Finally, display the welcome message
welcome_message

PATH="/home/droberts/perl5/bin${PATH+:}${PATH}"; export PATH;
PERL5LIB="/home/droberts/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/droberts/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/droberts/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/droberts/perl5"; export PERL_MM_OPT;

# Remap capslock to escape (for vim)
#xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'

# Load RVM into a shell session *as a function*
#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

############################################
# Ada Developers Academy
############################################

alias validate_html="java -jar /usr/local/lib/w3_validators/html_validator/vnu.jar --skip-non-html --errors-only *"

function fetch_project {
    # ARG 1 will be the project name; if not given, use the current directory name
    # assuming this will be run from a git checkout
    PROJECT=${1:=`basename \`pwd\``}
    for STUDENT in `cat ~/Ada/c8_pipes_usernames.txt`
    do
        NAME=`echo $STUDENT | cut -f 1 -d ':'`
        ACCOUNT=`echo $STUDENT | cut -f 2 -d ':'`
        echo "Name: $NAME, Acct: $ACCOUNT"
        git remote add $NAME "git@github.com:$ACCOUNT/$PROJECT.git"
        git fetch $NAME || git remote remove $NAME
    done
}

function grade_rails {
  STUDENT="$1"
  echo "Grading $STUDENT"
  git reset --hard HEAD && git clean -f && git checkout $STUDENT/master || return
  bundle install
  rails db:reset
  rails server
}

############################################
# /Ada Developers Academy
############################################

export PATH="/usr/local/opt/opencv3/bin:$PATH"

# Turn off history expansion, since it's not used and exclamation
# marks are actually pretty fun
setopt no_bang_hist
