# .bashrc

export PATH="$PATH":/home/pcon/Dropbox/bin/:$HOME/bin/
export XDG_CONFIG_HOME=$HOME/.config

export GREP_COLOR="1;31"

export EDITOR='vim'

alias grep="grep --color"
alias ls="ls --color=always"

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

function rmuntracked() {
	cd /home/pcon/ccm/src/
	git ls-files . --exclude-standard --others | while read FILE; do rm "$FILE"; done
}

function pseq() {
	x=$1
	y=$2
	format="%0${#y}d\n"
	for i in $(seq $x $y); do printf "$format" $i; done
}

IS_MAIL=`echo "."$IS_MAIL`

if [ $IS_MAIL = ".true" ]
then
	if [ $TERM != "screen" ]
	then
		screen -S mail -Rd -c ~/.screenrc-mail && exit
	fi
fi

IS_CHAT=`echo "."$IS_CHAT`

if [ $IS_CHAT = ".true" ]
then
	if [ $TERM != "screen" ]
	then
		screen -S chat -Rd -c ~/.screenrc-chat && exit
	fi
fi

IS_SFDC=`echo "."$IS_SFDC`

if [ $IS_SFDC = ".true" ]
then
	if [ $TERM != "screen" ]
	then
		cd ~/ccm/src/
		screen -S sfdc -Rd -c ~/.screenrc-sfdc && exit
	fi
fi

IS_STRATA=`echo "."$IS_STRATA`

if [ $IS_STRATA = ".true" ]
then
	if [ $TERM != "screen" ]
	then
		screen -S strata -Rd -c ~/.screenrc-strata && exit
	fi
fi

xset b off &> /dev/null

declare -x OLDPWD="/home/pcon/"

source $HOME/.bashrc_local

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi