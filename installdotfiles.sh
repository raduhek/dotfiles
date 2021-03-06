#!/bin/bash
IFS='.' read -r -a ver <<< `lsb_release -rs`
let u=${ver[0]}*100+${ver[1]}


apt-get update
if [[ $u < 1700 ]]; then
    add-apt-repository ppa:jonathonf/vim
fi
apt-get install -y tmux vim python3 python3-pip virtualenv python-virtualenv python3-virtualenv virtualenvwrapper python-dev python3-dev python-pip python3-pip
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
vim +PluginInstall +qall
cd ./.vim/bundle/youcompleteme && ./install.py --clang-completer
pip install --upgrade pip
pip install powerline-status

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
sudo apt-get install wget tar libevent-dev libncurses-dev
VERSION=2.6 && mkdir ~/tmux-src && wget -qO- https://github.com/tmux/tmux/releases/download/2.6/tmux-2.6.tar.gz | tar xvz -C ~/tmux-src && cd ~/tmux-src/tmux*
cd ~/tmux-src/tmux-2.6/
./configure && make -j"$(nproc)" && sudo make install
cd && rm -rf ~/tmux-src
