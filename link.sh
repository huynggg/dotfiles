#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ln -sf $SCRIPT_DIR/.bashrc ~/.bashrc
ln -sf $SCRIPT_DIR/.zshrc ~/.zshrc
#ln -sf $SCRIPT_DIR/.vimrc ~/.vimrc
ln -sf $SCRIPT_DIR/.gitconfig ~/.gitconfig
ln -sf $SCRIPT_DIR/.viminfo ~/.viminfo
ln -sf $SCRIPT_DIR/.p10k.zsh ~/.p10k.zsh
ln -sf $SCRIPT_DIR/.config ~/.config
ln -sf $SCRIPT_DIR/.git ~/.git

source ~/.bashrc
source ~/.zshrc
source ~/.vimrc
source ~/.gitconfig
source ~/.viminfo
source ~/.p10k.zsh
source ~/.config/nvim/init.vim
#source -r ~/.git/*
