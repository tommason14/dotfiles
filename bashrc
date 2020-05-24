if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

if [[ $USER =~ (tommason|tmas0023) ]]; then
  cat ~/.cache/wal/sequences # load on new terminal sessions

  BASE16_SHELL="$HOME/.config/base16-shell/"
  [ -n "$PS1" ] && 
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && 
      eval "$("$BASE16_SHELL/profile_helper.sh")"

  export EDITOR=/usr/local/bin/vim # explicitly declare brew-installed vim
else
  export EDITOR=vim
fi
