#!/bin/bash

dir=~/dotfiles

ipython=~/.ipython/profile_default/startup/start.ipy
jupyter_css=~/.jupyter/custom/custom.css
yabairc=~/.config/yabai/yabairc
skhdrc=~/.config/skhd/skhdrc
wal=~/.config/wal/templates

if [[ $USER =~ (tommason|tmas0023) ]]; then
  files="bash_functions vimrc pymolrc hyper.js chunkwmrc skhdrc Rprofile
amethyst"    
  [[ -L $ipython ]] || (echo "Linking ipythonrc" && ln -s $dir/jupyter/ipythonrc $ipython)
  [[ -L $jupyter_css ]] || (echo "Linking jupyter css" && ln -s
$dir/jupyter/custom.css $jupyter_css)
  [[ -L $yabairc ]] || (echo "Linking yabairc" && ln -s $dir/yabairc $yabairc)
  [[ -L $skhdrc ]] || (echo "Linking skhdrc" && ln -s $dir/skhdrc $skhdrc)
  # pywal atom theme
  # uses a package found here: https://github.com/ClydeDroid/dotfiles/tree/master/.atom/packages/wal-syntax
  [[ ! -d $wal ]] && mkdir -p $wal
  [[ ! -L "$wal/colors-atom-syntax" ]] && ln -s $dir/wal/colors-atom-syntax $wal/colors-atom-syntax
  # spicetify
  [[ ! -L "$wal/spicetify_colours.ini" ]] && ln -s $dir/wal/spicetify_colours.ini $wal/spicetify_colours.ini
  mkdir -p $HOME/spicetify_data/Themes/pywal && touch $HOME/spicetify_data/Themes/pywal/user.css
  # pywal makes the theme and wl/make_wallpaper.sh copies the theme into the
  # spicetify directory
else # remotes
  files="bash_functions vimrc"    
fi

cd $dir
for file in $files; do
    [[ -L ~/.$file ]] || ln -s $dir/$file ~/.$file
done

# Machine-specific

# [[ -d ~/.config/ranger ]] || mkdir ~/.config/ranger
[[ -d ~/.config/lf ]] || mkdir ~/.config/lf

alias_symlink=~/.bash_aliases
lf_symlink=~/.config/lf/lfrc
# ranger_symlink=~/.config/ranger/rc.conf

make_links(){
  [[ -L $alias_symlink ]] || (
  echo "Symlinking $dir/aliases/aliases.$1 --> $alias_symlink" &&
  ln -s $dir/aliases/aliases.$1 $alias_symlink)
  [[ -L $lf_symlink ]] || (
  echo "Symlinking $dir/lf/lfrc.$1 --> $lf_symlink" &&
  ln -s $dir/lf/lfrc.$1 $lf_symlink)
  # [[ -L $ranger_symlink ]] || (
  # echo "Symlinking $dir/ranger/rc.conf.$1 --> $ranger_symlink" &&
  # ln -s $dir/ranger/rc.conf.$1 $ranger_symlink)
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

# atom symlinks on local

if [[ $USER =~ (tmas0023|tommason) ]]
then
for f in $(find $dir/atom -type f)
do
  base=$(basename $f)
  orig="$dir/atom/$f"
  target="$HOME/.atom/$base"
  if [[ ! -L $target ]]; then
    echo "Linking $base for atom"
    ln -s "$orig" "$target"
  fi
done

# vscode symlinks on local
vsdir="$HOME/Library/Application Support/Code/User"
[[ ! -L "$vsdir/settings.json" ]] && ln -s "$dir/vscode/settings.json" "$vsdir/settings.json"
[[ ! -L "$vsdir/keybindings.json" ]] && ln -s "$dir/vscode/keybindings.json" "$vsdir/keybindings.json"
[[ ! -d "$vsdir/snippets" ]] && ln -s "$dir/vscode/snippets/" "$vsdir"

zathuradir="$HOME/.config/zathura"
[[ ! -d $zathuradir ]] && mkdir -p "$zathuradir"
ln -s "$dir/zathurarc" "$zathuradir"
fi
