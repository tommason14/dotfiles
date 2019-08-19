#!/bin/bash

dir=~/dotfiles

vscode_md=~/Library/Application\ Support/Code/User/snippets/markdown.json
ipython=~/.ipython/profile_default/startup/start.ipy
jupyter_css=~/.jupyter/custom/custom.css

if [[ $PWD == *"tommason"* || $PWD == *"tmas0023"* || $PWD == *"/Volumes/GoogleDrive"* ]]; then
  files="bash_functions vim vimrc pymolrc hyper.js chunkwmrc skhdrc Rprofile"    
  [[ -L $vscode_md ]] || ln -s $dir/vscode/markdown.json $vscode_md
  [[ -L $ipython ]] || ln -s $dir/jupyter/ipythonrc $ipython
  [[ -L $jupyter_css ]] || ln -s $dir/jupyter/custom.css 
else # remotes
  files="bash_functions vim vimrc"    
fi


cd $dir
for file in $files; do
    [[ -L ~/.$file ]] || ln -s $dir/$file ~/.$file
done


[[ -d ~/.config/ranger ]] || mkdir ~/.config/ranger
[[ -d ~/.config/lf ]] || mkdir ~/.config/lf

alias_symlink=~/.bash_aliases
lf_symlink=~/.config/lf/lfrc
ranger_symlink=~/.config/ranger/rc.conf

if [[ $PWD == *"tommason"* ]]; then
  [[ -L $alias_symlink ]] || (
  echo "Symlinking $dir/aliases/aliases.macbook --> $alias_symlink" && 
  ln -s $dir/aliases/aliases.macbook $alias_symlink)
  [[ -L $lf_symlink ]] || (
  echo "Symlinking $dir/lf/lfrc.macbook --> $lf_symlink" &&
  ln -s $dir/lf/lfrc.macbook $lf_symlink)
  [[ -L $ranger_symlink ]] || (
  echo "Symlinking $dir/ranger/rc.conf.macbook --> $ranger_symlink" &&
  ln -s $dir/ranger/rc.conf.macbook $ranger_symlink)
fi

configs="raijin magnus m3 monarch stampede MU00151959X"

for config in ${configs[@]}; do
  if [[ $HOSTNAME == *"$config"* ]]; then
    [[ -L $alias_symlink ]] || (
    echo "Symlinking $dir/aliases/aliases.$config --> $alias_symlink" &&
    ln -s $dir/aliases/aliases.$config $alias_symlink)
    [[ -L $lf_symlink ]] || (
    echo "Symlinking $dir/lf/lfrc.$config --> $lf_symlink" &&
    ln -s $dir/lf/lfrc.$config $lf_symlink)
    [[ -L $ranger_symlink ]] || (
    echo "Symlinking $dir/ranger/rc.conf.$config --> $ranger_symlink" &&
    ln -s $dir/ranger/rc.conf.$config $ranger_symlink)
  fi
done
