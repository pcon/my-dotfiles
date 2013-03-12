#!/bin/bash
DFILES=dotfiles

sudo yum -y install vim-enhanced pyflakes python-pip fontforge
sudo pip-python install dotfiles
cd $HOME
git clone git@github.com:pcon/my-dotfiles.git $DFILES
cd $HOME/$DFILES
git submodule init
git submodule update
cd $HOME
cp $HOME/dotfiles/dotfilesrc $HOME/.dotfilesrc
dotfiles --sync --force