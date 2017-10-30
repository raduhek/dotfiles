#!/bin/bash
IFS='.' read -r -a ver <<< `lsb_release -rs`
let u=${ver[0]}*100+${ver[1]}


apt-get update
if [[ $u < 1700 ]]; then
    add-apt-repository ppa:jonathonf/vim
fi
apt-get install -y tmux vim python3 python3-pip virtualenv python-virtualenv python3-virtualenv virtualenvwrapper
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
vim +PluginInstall +qall
