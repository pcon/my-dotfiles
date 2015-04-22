# .bashrc

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoreboth:erasedups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Convenience functions for adding to and removing
# from PATH
function append_path {
	if [ -d $1 ] ; then
		export PATH=$PATH:$1
	fi
}

function remove_path {
	export PATH=${PATH%%:$1}
}

if [ -f $HOME/.bashrc_local ]; then
	. $HOME/.bashrc_local
fi

#
# Define some colors first: Capitals denote bold
#
red='\e[0;31m'
RED='\e[1;31m'
green='\e[0;32m'
GREEN='\e[1;32m'
yellow='\e[0;33m'
YELLOW='\e[1;33m'
blue='\e[0;34m'
BLUE='\e[1;34m'
magenta='\e[0;35m'
MAGENTA='\e[1;35m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
NC='\e[0m'              # No Color

# Taken from http://www.opinionatedprogrammer.com/2011/01/colorful-bash-prompt-reflecting-git-status/
function _git_prompt() {
	local git_status="`git status -unormal 2>&1`"
	if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
		if [[ "$git_status" =~ nothing\ to\ commit ]]; then
			local ansi=$GREEN
		elif [[ "$git_status" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
			local ansi=$RED
		else
			local ansi=$YELLOW
		fi
		if [[ "$git_status" =~ On\ branch\ ([^[:space:]]+) ]]; then
			branch=${BASH_REMATCH[1]}
			#test "$branch" != master || branch=' '
		else
			# Detached HEAD.  (branch=HEAD is a faster alternative.)
			branch="(`git describe --all --contains --abbrev=4 HEAD 2> /dev/null ||
					echo HEAD`)"
		fi
		echo -n '[\['"$ansi"'\]'"$branch"'\[\e[0m\]]'
	fi
}

function report_status() {
	RET_CODE=$?
	if [[ $RET_CODE -ne 0 ]] ; then
		echo -ne "[\[$RED\]$RET_CODE\[$NC\]]"
	fi
}

export _PS1="\[$NC\][\u@\h \W]"
export PS2="\[$NC\]> "
export PROMPT_COMMAND='_status=$(report_status);export PS1="$(_git_prompt)${_status}${_PS1}\$ ";unset _status;'

append_path $HOME/Dropbox/bin
append_path $HOME/bin

export XDG_CONFIG_HOME=$HOME/.config
export GREP_COLOR="1;31"
export EDITOR='vim'

alias grep="grep --color"
alias ls="ls --color=always"
alias bunyan="bunyan -o short"

if [ -e $HOME/.dircolors ]
then
	eval `dircolors $HOME/.dircolors`
fi

function listprinters() {
	lpstat -t
}

function swap() {
	TMP_NAME="TMP_$RANDOM"
	mv "$1" "/tmp/$TMP_NAME" && mv "$2" "$1" && mv "/tmp/$TMP_NAME" "$2"
}

function pseq() {
	x=$1
	y=$2
	format="%0${#y}d\n"
	for i in $(seq $x $y); do printf "$format" $i; done
}

function findfile() {
	name=$1
	find . -iname "*$name*"
}

function cb() {
	local _scs_col="\x1B[0;32m"; local _wrn_col='\x1B[1;31m'; local _trn_col='\x1B[0;33m'

	XCLIP_LOC=`which xclip`
	PBCOP_LOC=`which pbcopy`

	if [ -z "$XCLIP_LOC" ] && [ -z "$PBCO_LOC " ]; then
		echo -e "$_wrn_col""You must have the 'xclip' or 'pbcopy' program installed.\x1B[0m"
	elif [[ "$USER" == "root" ]]; then
		echo -e "$_wrn_col""Must be regular user (not root) to copy a file to the clipboard.\x1B[0m"
	else
		if ! [[ "$( tty )" == /dev/* ]]; then
			input="$(< /dev/stdin)"
		else
			input="$*"
		fi

		if [ -z "$input" ]; then
			echo "Copies a string to the clipboard."
			echo "Usage: cb <string>"
			echo "       echo <string> | cb"
		else
			if [ -n "$XCLIP_LOC" ]; then
				echo -n "$input" | xclip -selection c
			else
				echo -n "$input" | pbcopy
			fi
			if [ ${#input} -gt 80 ]; then input="$(echo $input | cut -c1-80)$_trn_col...\x1B[0m"; fi
			echo -e "$_scs_col""Copied to clipboard:\x1B[0m $input"
		fi
	fi
}

function cbf() {
	cat "$1" | cb;
}

function xmlformat() {
	f=$1
	TMP_NAME="TMP_$RANDOM"
	cat "$1" | xmllint --format - > "/tmp/$TMP_NAME"
	mv "/tmp/$TMP_NAME" "$1"
}

xset b off &> /dev/null

if [ -e $HOME/.perpetual_screen ]; then
	. $HOME/.perpetual_screen
fi

declare -x OLDPWD="/home/pcon/"