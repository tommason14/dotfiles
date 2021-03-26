if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

export EDITOR=vim

export PYTHONPATH=$PYTHONPATH:/Users/tmas0023/pysimm
export PATH=$PATH:/Users/tmas0023/pysimm/bin

set -o vi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
