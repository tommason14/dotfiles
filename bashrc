if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

if [[ $USER =~ (tommason|tmas0023) ]]; then
  export EDITOR=/usr/local/bin/vim # explicitly declare brew-installed vim
else
  export EDITOR=vim
fi

# [[ $USER == "tommason" ]] && cat ~/.cache/wal/sequences
[[ $USER =~ (tommason|tmas0023) ]] &&
  BASE16_SHELL="$HOME/.config/base16-shell/"
  [ -n "$PS1" ] && 
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && 
      eval "$("$BASE16_SHELL/profile_helper.sh")"

export PYTHONPATH=$PYTHONPATH:/Users/tmas0023/pysimm
export PATH=$PATH:/Users/tmas0023/pysimm/bin
