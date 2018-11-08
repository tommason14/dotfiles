CYAN='\033[0;36m'
NO_COLOUR='\033[0m'
export PS1='\[\033[0;36m\]\D{%d/%m %H:%M} \W $ \[\033[0m\]'
EDITOR=vim

# edit dotfiles, but they are linked to the home directory, so source the home directory
alias bashrc='vim ~/dotfiles/bashrc && source ~/.bashrc'
alias bash_aliases='vim ~/dotfiles/bash_aliases && source ~/.bashrc'
alias bash_functions='vim ~/dotfiles/bash_functions && source ~/.bashrc'
alias vimrc='vim ~/dotfiles/vimrc'
alias dotfiles='cd ~/dotfiles'

# aliases for default commands
alias l='ls'
alias lsa='ls -a'
alias c='clear'
alias mkdir='mkdir -p'


alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias desktop='cd ~/Desktop'
alias dk='cd ~/Desktop'
alias downloads='cd ~/Downloads'
alias dw='cd ~/Downloads'
alias documents='cd ~/Documents'
alias dc='cd ~/Documents'

alias site='cd ~/Documents/Web\ Design/sites/personal-site'

alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'

#static sites
alias hc='mv node_modules/ _node_modules/ && harp compile && mv _node_modules/ node_modules/'
alias hs='harp server'
alias js='jekyll serve'

# applications

alias avo='/Applications/Avogadro.app/Contents/MacOS/Avogadro'
alias avogadro='/Applications/Avogadro.app/Contents/MacOS/Avogadro'
alias jn='jupyter notebook'


# monash
alias raijin='ssh tm3124@raijin.nci.org.au'
alias magnus='ssh tmason@magnus.pawsey.org.au'
alias gaia='ssh tmas0011@msgln6.its.monash.edu.au'
