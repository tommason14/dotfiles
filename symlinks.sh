#!/bin/bash

dir=~/dotfiles

ipython=~/.ipython/profile_default/startup/start.ipy
jupyter_css=~/.jupyter/custom/custom.css
yabairc=~/.config/yabai/yabairc
spacebarrc=~/.config/spacebar/spacebarrc
skhdrc=~/.config/skhd/skhdrc
wal=~/.config/wal/templates

if [[ $USER =~ (tommason|tmas0023) ]]; then
  files="bash_functions pymolrc hyper.js chunkwmrc skhdrc Rprofile
amethyst zshrc tmux.conf"    
  [[ -L $ipython ]] || (echo "Linking ipythonrc" && ln -s $dir/jupyter/ipythonrc $ipython)
  [[ -L $jupyter_css ]] || (echo "Linking jupyter css" && ln -s
$dir/jupyter/custom.css $jupyter_css)
  [[ -L $yabairc ]] || (echo "Linking yabairc" && ln -s $dir/yabairc $yabairc)
  [[ -L $spacebarrc ]] || (echo "Linking spacebarrc" && ln -s $dir/spacebarrc $spacebarrc)
  [[ -L $skhdrc ]] || (echo "Linking skhdrc" && ln -s $dir/skhdrc $skhdrc)
  # pywal atom theme
  # uses a package found here: https://github.com/ClydeDroid/dotfiles/tree/master/.atom/packages/wal-syntax
  mkdir -p $HOME/spicetify_data/Themes/pywal && touch $HOME/spicetify_data/Themes/pywal/user.css
  # pywal makes the theme and wl/make_wallpaper.sh copies the theme into the
  # spicetify directory
[[ -L ~/.zshrc ]] || (echo "Linking zshrc" && ln -s $dir/zshrc ~/.zshrc)

else # remotes
  files="bash_functions"    
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

make_links(){
  [[ -L $alias_symlink ]] || (
  echo "Symlinking $dir/aliases/aliases.$1 --> $alias_symlink" &&
  ln -s $dir/aliases/aliases.$1 $alias_symlink)
  [[ -L $lf_symlink ]] || (
  echo "Symlinking $dir/lf/lfrc.$1 --> $lf_symlink" &&
  ln -s $dir/lf/lfrc.$1 $lf_symlink)
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

[[ $USER == "mcd_thomasm" ]] && make_links "dug"

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
[[ ! -L "$zathuradir/zathurarc" ]] && ln -s "$dir/zathurarc" "$zathuradir/zathurarc"

kitdir="$HOME/.config/kitty"
[[ ! -L "$kitdir" ]] && ln -s "$dir/terminal" "$kitdir" && echo "Linking kitty config"

[[ ! -L "$wal" ]] && ln -s "$dir/wal" $wal && echo "Linking wal templates"

#vim
[[ ! -L ~/.vimrc ]] && ln -s "$dir/vim/vimrc" ~/.vimrc && echo "Linking vimrc"
mkdir -p ~/.config/nvim
[[ ! -L ~/.config/nvim/init.vim ]] && ln -s "$dir/vim/init.vim" ~/.config/nvim/init.vim && echo "Linking init.vim"
[[ ! -L ~/.config/nvim/coc-settings.json ]] && ln -s "$dir/vim/coc-settings.json" ~/.config/nvim/coc-settings.json && echo "Linking CoC"

# matplotlibrc
[[ ! -d ~/.matplotlib ]] && mkdir -p ~/.matplotlib
[[ ! -L ~/.matplotlib/matplotlibrc ]] && ln  -s "$dir/matplotlibrc" ~/.matplotlib/matplotlibrc && echo "Linking matplotlibrc"
fi

[[ ! -d ~/.config/bat ]] && mkdir ~/.config/bat
[[ ! -L ~/.config/bat/config ]] &&
  echo "Linking bat config" && 
  ln -s $dir/bat.config ~/.config/bat/config

# autochem
mols=~/.config/autochem/molecules.txt
[[ ! -d ~/.config/autochem ]] && mkdir ~/.config/autochem
[[ -f $mols ]] && rm $mols # if already present, remove and use this symlink
[[ ! -L $mols ]] && ln -s $dir/molecules.txt $mols

[[ $HOSTNAME =~ monarch ]] && ln -s ~/dotfiles/vim/monarch.init.vim ~/.config/nvim/init.vim
