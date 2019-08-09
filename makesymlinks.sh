#!/bin/bash
########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory

if [[ $PWD == *"tommason"* || $PWD == *"tmas0023"* || $PWD == *"/Volumes/GoogleDrive"* ]]; then
  files="bash_aliases bash_functions vim vimrc pymolrc hyper.js chunkwmrc skhdrc Rprofile"    
  ln -s $dir/vscode/markdown.json ~/Library/Application\ Support/Code/User/snippets/markdown.json
  ln -s $dir/jupyter/ipythonrc  ~/.ipython/profile_default/startup/start.ipy
  ln -s $dir/jupyter/custom.css ~/.jupyter/custom/custom.css
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

#### ranger/lf ####

if [[ $PWD == *"tommason"* || $PWD == *"tmas0023"* ]]; then
  echo "Symlinking $dir/ranger/rc.conf.local --> ~/.config/ranger/rc.conf"
  ln -s $dir/ranger/rc.conf.local ~/.config/ranger/rc.conf
  ln -s $dir/lf/lfrc ~/.config/lf/lfrc
fi

configs="raijin magnus m3 monarch stampede"

for config in ${configs[@]}; do
  if [[ $HOSTNAME == *"$config"* ]];
    then
    echo "Symlinking $dir/ranger/rc.conf.$config --> ~/.config/ranger/rc.conf"
    ln -s $dir/ranger/rc.conf.$config ~/.config/ranger/rc.conf
  fi
done
