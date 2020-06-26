#!/usr/bin/env bash

themes=($(ls -1 ~/.cache/wal/colors-kitty.conf ~/.config/kitty/themes/* | sed "s|$HOME|~|"))
num=$(( $RANDOM % ${#themes[@]} ))
new="${themes[$num]}"
sed -i '' "s|include.*conf|include $new|" ~/.config/kitty/kitty.conf
kitty @ set-colors --all --configured ~/.config/kitty/kitty.conf
