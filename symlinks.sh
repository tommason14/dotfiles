#!/bin/bash

dir=~/dotfiles

vscode_md=~/Library/Application\ Support/Code/User/snippets/markdown.json
ipython=~/.ipython/profile_default/startup/start.ipy
jupyter_css=~/.jupyter/custom/custom.css
yabairc=~/.config/yabai/yabairc
skhdrc=~/.config/skhd/skhdrc

if [[ $USER =~ (tommason|tmas0023) ]]; then
  files="bash_functions vim vimrc pymolrc hyper.js chunkwmrc skhdrc Rprofile
amethyst"    
  [[ -L $vscode_md ]] || (echo "Linking markdown.json" && ln -s $dir/vscode/markdown.json $vscode_md)
  [[ -L $ipython ]] || (echo "Linking ipythonrc" && ln -s $dir/jupyter/ipythonrc $ipython)
  [[ -L $jupyter_css ]] || (echo "Linking jupyter css" && ln -s
$dir/jupyter/custom.css $jupyter_css)
  [[ -L $yabairc ]] || (echo "Linking yabairc" && ln -s $dir/yabairc $yabairc)
  [[ -L $skhdrc ]] || (echo "Linking skhdrc" && ln -s $dir/skhdrc $skhdrc)
else # remotes
  files="bash_functions vim vimrc"    
fi

cd $dir
for file in $files; do
    [[ -L ~/.$file ]] || ln -s $dir/$file ~/.$file
done

# Machine-specific

[[ -d ~/.config/ranger ]] || mkdir ~/.config/ranger
[[ -d ~/.config/lf ]] || mkdir ~/.config/lf

alias_symlink=~/.bash_aliases
lf_symlink=~/.config/lf/lfrc
ranger_symlink=~/.config/ranger/rc.conf

make_links(){
  [[ -L $alias_symlink ]] || (
  echo "Symlinking $dir/aliases/aliases.$1 --> $alias_symlink" &&
  ln -s $dir/aliases/aliases.$1 $alias_symlink)
  [[ -L $lf_symlink ]] || (
  echo "Symlinking $dir/lf/lfrc.$1 --> $lf_symlink" &&
  ln -s $dir/lf/lfrc.$1 $lf_symlink)
  [[ -L $ranger_symlink ]] || (
  echo "Symlinking $dir/ranger/rc.conf.$1 --> $ranger_symlink" &&
  ln -s $dir/ranger/rc.conf.$1 $ranger_symlink)
}

if [[ $USER == "tommason" ]]; then
  make_links "macbook"
fi

configs="gadi raijin magnus m3 monarch stampede MU00151959X"

for config in ${configs[@]}; do
  if [[ $HOSTNAME == *"$config"* ]]; then
    make_links $config
  fi
done
