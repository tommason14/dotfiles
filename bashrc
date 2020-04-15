if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

if [[ $USER =~ (tommason|tmas0023) ]]; then
  cat ~/.cache/wal/sequences # load on new terminal sessions
  export EDITOR=/usr/local/bin/vim # explicitly declare brew-installed vim
else
  export EDITOR=vim
fi

export PYTHONPATH=$PYTHONPATH:/Users/tmas0023/pysimm
export PATH=$PATH:/Users/tmas0023/pysimm/bin
export PYTHONPATH=$PYTHONPATH:/Users/tmas0023/pysimm
export PATH=$PATH:/Users/tmas0023/pysimm/bin
