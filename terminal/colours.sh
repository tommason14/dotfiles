#!/usr/bin/env zsh

new=$(ls -1 ~/.cache/wal/colors-kitty.conf ~/.config/kitty/themes/* | fzf | sed "s|$HOME|~|") 
[[ $new == "" ]] && new="~/.cache/wal/colors-kitty.conf"
sed -i '' "s|include.*conf|include $new|" ~/.config/kitty/kitty.conf
kitty @ set-colors --all --configured ~/.config/kitty/kitty.conf
