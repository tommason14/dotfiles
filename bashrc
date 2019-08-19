if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

if [[ $PWD == *"tommason"* || $HOSTNAME == "MU00151959X" ]]; then
  cat ~/.cache/wal/sequences # load on new terminal sessions
fi
