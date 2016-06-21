#!/usr/bin/env bash

link_list=()
link_list+=("i3config:$HOME/.i3/config")
link_list+=("i3bin:$HOME/.i3/bin")
link_list+=("bashrc:$HOME/.bashrc")
link_list+=("inputrc:$HOME/.inputrc")
link_list+=("vimrc:$HOME/.vimrc")
link_list+=("vimrc:$HOME/.nvimrc")
link_list+=("vimrc:$HOME/.config/nvim/init.vim")
link_list+=("gitconfig:$HOME/.gitconfig")
link_list+=("dunstrc:$HOME/.config/dunst/dunstrc")

function verbose_eval() {
    echo "$1" & eval "$1"
}

function make_link() {
    if [ ! -e $2 ]
    then
        directory=$(dirname $2)
        verbose_eval "mkdir -p \"$directory\""
        verbose_eval "ln -s \"$1\" \"$2\""
    else
        echo "Target \"$2\" already exists - skipping."
    fi
}

git submodule init
git submodule update

curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

for link in "${link_list[@]}"
do
    src="$(pwd)/$(echo $link | cut -d':' -f1)"
    dest=$(echo $link | cut -d':' -f2)
    make_link "$src" "$dest"
done

