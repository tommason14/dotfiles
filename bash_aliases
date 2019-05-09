#!/usr/bin/env sh
CYAN='\[\e[0;36m\]'
NO_COLOUR='\[\e[0m\]'
if [[ $HOSTNAME == "MU00151959X" ]]; then
  export PS1="${CYAN}Local \W >> ${NO_COLOUR}"
elif [[ $HOSTNAME == *"stampede2.tacc.utexas.edu" ]]; then
  export PS1="Stampede2 \W $ "
else
  export PS1="${CYAN}\h \W >> ${NO_COLOUR}"
fi

EDITOR=vim

if [[ $PWD == *"tmas0023"* ]]; then
    export PATH=~/Google_Drive/bin:/usr/local/opt/make/libexec/gnubin:~/dotfiles/python_wrappers:/usr/local/texlive/2018/bin/x86_64-darwin:/Users/tmas0023/Documents/monash_automation:$PATH
    export PYTHONPATH=~/Documents/monash_automation/:$PYTHONPATH
    alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
    alias automation='cd ~/Documents/monash_automation'
    alias vmd='/Applications/VMD\ 1.9.3.app/Contents/vmd/vmd_MACOSXX86'
fi

if [[ $PWD == *"tommason"* ]]; then
    export PATH=$PATH:~/bin:~/Google_Drive/bin:~/dotfiles/python_wrappers:~/Documents/Monash/monash_automation:~/.cargo/bin
    export PYTHONPATH=~/Documents/Monash/monash_automation:$PYTHONPATH
    alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
    alias automation='cd ~/Documents/Monash/monash_automation'

    alias uni='ssh tmas0023@dyn-130-194-161-79.its.monash.edu.au'

    #static sites
    alias hs='harp server'
    alias js='jekyll serve'
fi

# raijin
if [[ $PWD == *"565"* || $PWD == *"k96"* ]]; then
    export PATH=/home/565/tm3124/.linuxbrew/bin:/home/565/tm3124/py-37/bin:/home/565/tm3124/monash_automation:$PATH
    export PYTHONPATH=~/monash_automation/chem_assistant:$PYTHONPATH
    alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"' 
    alias job_count='qstat -u tm3124 | grep tm3124 | wc -l'
    alias automation='cd ~/monash_automation'
    
    alias gspec='cp /~/monash_automation/chem_assistant/templates/gamess_meta/spec/meta.py .'
    alias pspec='cp ~/monash_automation/chem_assistant/templates/psi_meta/spec/meta.py .'
fi

# magnus
if [[ $PWD == *"tmason"* && $HOSTNAME == *"magnus"* ]]; then
    export PATH=~/monash_automation:$PATH
    export PYTHONPATH=~/monash_automation/chem_assistant:$PYTHONPATH
    alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"' 
    alias job_count='squeue | grep tmason | wc -l'
    alias automation='cd ~/monash_automation'
fi

#stampede2
if [[ $PWD == *"tmason"* && $HOSTNAME == *"stampede"* ]]; then
    export PATH=~/monash_automation:$PATH
    export PYTHONPATH=~/monash_automation/chem_assistant:$PYTHONPATH
    alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"' 
    alias automation='cd ~/monash_automation'
fi

# monarch/massive
if [[ $PWD == *"tmason1"* ]]; then
    export PATH=~/monash_automation/:$PATH
    export PYTHONPATH=~/monash_automation/chem_assistant:$PYTHONPATH
    alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"' 
    alias job_count='squeue | grep tmason1 | wc -l'
    alias automation='cd ~/monash_automation'
fi

# edit dotfiles, but they are linked to the home directory, so source the home directory
alias bashrc='vim ~/.bashrc && source ~/.bashrc'
alias bash_aliases='vim ~/dotfiles/bash_aliases && source ~/.bashrc'
alias bash_functions='vim ~/dotfiles/bash_functions && source ~/.bashrc'
alias vimrc='vim ~/dotfiles/vimrc'
alias dotfiles='cd ~/dotfiles'
alias hyperjs='vim ~/dotfiles/hyper.js'

# aliases for default commands
alias l='ls'
alias ld='ls'
alias lsa='ls -a'
alias ll='ls -lh'
alias c='clear'
alias mkdir='mkdir -p'

alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../..'
alias .....='cd ../../../..'


if [[ $PWD == *"tommason"* || $PWD == *"tmas0023"* ]]; then

  alias ls='ls -G'
  alias desktop='cd ~/Desktop'
  alias dk='cd ~/Desktop'
  alias downloads='cd ~/Downloads'
  alias dw='cd ~/Downloads'
  alias documents='cd ~/Documents'
  alias dc='cd ~/Documents'
  alias mo='cd ~/Movies'
  alias pc='cd ~/Pictures'
  alias google='cd ~/Google_Drive'
  alias scripts='cd ~/Google_Drive/scripts'
  alias backups='cd ~/Google_Drive/backups'
  alias analysis='cd ~/Google_Drive/Hydrated_ILs/Analysis'
  alias jn='jupyter notebook'
  alias gtqcp='cd ~/Google_Drive/scripts/qcp'
  
  alias compile_thesis="watchman -- trigger . make_pdf_file '**/*.tex' -- make compile" 
  alias pandoc_citeproc='pandoc --filter pandoc-citeproc'

  # monash
  alias raijin='sshpass -f ~/dotfiles/sshfile ssh -XY tm3124@raijin.nci.org.au' # Y allows for displaying graphs- sets a $DISPLAY environment variable?
  alias magnus='sshpass -f ~/dotfiles/sshfile ssh tmason@magnus.pawsey.org.au'
  alias gaia='sshpass -f ~/dotfiles/sshfile ssh -X tmas0011@msgln6.its.monash.edu.au'
  alias m3='sshpass -f ~/dotfiles/sshfile ssh tmason1@m3.massive.org.au'
  # alias monarch='ssh -Y tmason1@monarch-login1.erc.monash.edu.au'
  alias monarch='sshpass -f ~/dotfiles/sshfile ssh -Y tmason1@monarch.erc.monash.edu.au'
  alias stampede='~/dotfiles/sshstam'
  alias qcp='python3 ~/Google_Drive/Scripts/qcp/qcp/__main__.py'
  alias lammps_dir='cd /usr/local/share/lammps'
  alias polymers='cd ~/Google\ Drive/Polymers'

  alias ga='git add .'
  alias gs='git status'
  alias gc='git commit'
  alias gca='git commit --amend'
  alias gp='git push'
  alias gpf='git push -f'
  alias gd='git diff'

  alias size='du -sh'
  alias xelatex_fonts='fc-list : family | cut -f1 -d"," | sort'
  alias paper='cd ~/Google_Drive/Hydrated_ILs/Publishing/Write_up/current/'
  alias thesis='cd ~/Google_Drive/thesis/'
  alias wordcount='pandoc --lua-filter wordcount.lua source/*.md'
fi

# plots everywhere
alias plotpcm="grep 'EMP2+EPCM' | tr -s [:blank:] | cut -d ' ' -f 3 | gnuplot -e \"set terminal dumb; plot '-' with lines notitle\""
alias plotmp2="grep 'E(MP2)' | sed '/NaN/d' | tr -s [:blank:] | cut -d ' ' -f 3 | gnuplot -e \"set terminal dumb; plot '-' with lines notitle\""
alias plotfmo="grep 'E corr MP2(2)=' | tr -s [:blank:] | cut -d ' ' -f 10 | gnuplot -e \"set terminal dumb; plot '-' with lines notitle\""
alias plotgauss="grep 'SCF Done' | tr -s [:blank:] | cut -d ' ' -f 6 | gnuplot -e \"set terminal dumb; plot '-' with lines notitle\""

# sort energies
alias sortmp2="grep 'E(MP2)' | tr -s [:blank:] | cut -d ' ' -f 3 | nl | sort -nr -k 2"

# gaussian frequencies
alias check_gauss_freqs='find . -path "*log" | while read file; do echo "$file"; gauss_freqs "$file"; done'

# total file size of all files from find command
alias total_filesize="xargs stat -c %s | awk '{total+=\$1} END {print total}'"

alias ra='ranger'
alias vundle='git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim'
