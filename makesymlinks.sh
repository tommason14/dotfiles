#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory

if [[ $PWD == *"tommason"* || $PWD == *"tmas0023"* ]]; then
  files="bash_aliases bash_functions vim vimrc pymolrc hyper.js config/ranger/rc.conf chunkwmrc skhdrc"    
  ln -s $dir/vscode/markdown.json ~/Library/Application\ Support/Code/User/snippets/markdown.json
else # remotes
  files="bash_aliases bash_functions vim vimrc"    
fi

# removed bashrc as it is already present on stampede2, don't want to overwrite

##########

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file ~/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

