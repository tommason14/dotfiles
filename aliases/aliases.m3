#!/usr/bin/env sh
# prompt {{{1

CYAN='\[\e[0;36m\]'
NO_COLOUR='\[\e[0m\]'
DATE=$(date '+%d/%m')
if [[ $HOSTNAME == "MU00151959X" ]]; then
  export PS1="${CYAN}${DATE} Local \W \$ ${NO_COLOUR}"
elif [[ $HOSTNAME == *"stampede2.tacc.utexas.edu" ]]; then
  export PS1="${CYAN}${DATE} Stampede \W \$ ${NO_COLOUR}"
else
  export PS1="${CYAN}${DATE} \h \W \$ ${NO_COLOUR}"
fi

EDITOR=vim

# uni mac or macbook {{{1

if [[ $PWD == *"tmas0023"* || $PWD == *"tommason"* || $PWD == *"/Volumes/GoogleDrive"* ]]; then
    export filestream="/Volumes/GoogleDrive/My Drive"
    export repos="$HOME/Documents/repos"
    export PATH=$repos/chem_scripts:$repos/scripts:"$filestream"/bin:~/bin:/usr/local/opt/make/libexec/gnubin:~/dotfiles/python_wrappers:/usr/local/texlive/2018/bin/x86_64-darwin:$repos/monash_automation:$PATH
    export PYTHONPATH=$repos/monash_automation/:$PYTHONPATH
    alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
    alias automation="cd $repos/monash_automation"
    export automation="$repos/monash_automation"
    if [[ $HOSTNAME != *"MBP"* ]] 
    then
      alias vmd='/Applications/VMD\ 1.9.3.app/Contents/vmd/vmd_MACOSXX86'
    fi

    #static sites
    alias hs='harp server'
    alias js='jekyll serve'
fi

# raijin {{{1

if [[ $PWD == *"565"* || $PWD == *"k96"* ]]; then
    export PATH=~/chem_scripts:/home/565/tm3124/.linuxbrew/bin:/home/565/tm3124/py-37/bin:/home/565/tm3124/monash_automation:$PATH
    export PYTHONPATH=~/monash_automation:$PYTHONPATH
    alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"' 
    alias job_count='qstat -u tm3124 | grep tm3124 | wc -l'
    alias automation='cd ~/monash_automation'
    
    alias gspec='cp /~/monash_automation/chem_assistant/templates/gamess_meta/spec/meta.py .'
    alias pspec='cp ~/monash_automation/chem_assistant/templates/psi_meta/spec/meta.py .'
fi

# magnus {{{1

if [[ $PWD == *"tmason"* && $HOSTNAME == *"magnus"* ]]; then
    export PATH=~/chem_scripts:~/monash_automation:$PATH
    export PYTHONPATH=~/monash_automation:$PYTHONPATH
    alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"' 
    alias job_count='squeue | grep tmason | wc -l'
    alias automation='cd ~/monash_automation'
fi

# stampede2 {{{1

if [[ $PWD == *"tmason"* && $HOSTNAME == *"stampede"* ]]; then
    export PATH=~/chem_scripts:~/monash_automation:$PATH
    export PYTHONPATH=~/monash_automation:$PYTHONPATH
    alias ranger='eval $(resize) && ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"' 
    alias automation='cd ~/monash_automation'
    alias job_count='squeue | grep tmason | wc -l'
    function pf {
    smooth_fluorescence_data.py -f $1
    cat spectra.data | awk -F "," '{print $4, $5}' | sed '1d' | gnuplot -e "set terminal dumb; plot '-' with lines notitle"
    }
fi

# monarch/massive {{{1

if [[ $PWD == *"tmason1"* ]]; then
    export PATH=~/chem_scripts:~/monash_automation/:$PATH
    export PYTHONPATH=~/monash_automation:$PYTHONPATH
    alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"' 
    alias job_count='squeue | grep tmason1 | wc -l'
    alias automation='cd ~/monash_automation'
fi

# gaia {{{1

if [[ $PWD == *"nfs"* ]]; then
    alias ranger='python3 ~/ranger/ranger.py --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"' 
fi

# local {{{1

if [[ $USER =~ (tommason|tmas0023) ]]; then

  alias analysis='cd "$filestream"/Hydrated_ILs/Analysis'
  alias backups='cd "$filestream"/backups'
  alias ccat='highlight --out-format=ansi'
  alias dc='cd ~/Documents'
  alias desktop='cd ~/Desktop'
  alias dk='cd ~/Desktop'
  alias documents='cd ~/Documents'
  alias downloads='cd ~/Downloads'
  alias dw='cd ~/Downloads'
  alias gd='cd "$filestream"/Dopamine'
  alias google='cd "$filestream"'
  alias gp='cd "$filestream"/polymers'
  alias gq='cd $repos/qcp'
  alias grep='grep --color'
  alias jl='jupyter-lab'
  alias ls='ls -G'
  alias mccg='cd $repos/mccg'
  alias mo='cd ~/Movies'
  alias pc='cd ~/Pictures'
  alias polymers='cd "$filestream"/Polymers'
  alias scripts='cd "$filestream"/scripts'
  
  ### open applications

  function pymol { # used as an alias
   /Applications/PyMOL.app/Contents/MacOS/PyMOL $@ -d "@~/.pymolrc"
  }
  alias ia="open -a /Applications/iA\ Writer.app/"
  alias avo="open -a /Applications/Avogadro.app/"
  alias iqmol="open -a /Applications/IQmol.app/"
  alias deckset="open -a /Applications/Deckset.app/"
  
  alias chunkstart='brew services start chunkwm && brew services start skhd'
  alias chunkstop='brew services stop chunkwm && brew services stop skhd'

  # monash
  alias raijin='sshpass -f ~/dotfiles/sshfile ssh -XY tm3124@raijin.nci.org.au'
  alias magnus='sshpass -f ~/dotfiles/sshfile ssh -Y tmason@magnus.pawsey.org.au'
  alias gaia='sshpass -f ~/dotfiles/sshfile ssh -Y -t tmas0011@msgln6.its.monash.edu.au "cd /nfs/shares/pas-grp/TOM; bash"'
  alias m3='sshpass -f ~/dotfiles/sshfile ssh -Y tmason1@m3.massive.org.au'
  alias monarch='sshpass -f ~/dotfiles/sshfile ssh -Y tmason1@monarch.erc.monash.edu.au'
  alias stampede='~/dotfiles/sshstam'
  alias vault='sshpass -f ~/dotfiles/sshfile ssh tmason1@118.138.242.229'
  alias qcp='python3 ~/Google_Drive/Scripts/qcp/qcp/__main__.py'
  alias lammps_dir='cd /usr/local/share/lammps'

  alias size='du -sh'
  alias xelatex_fonts='fc-list : family | cut -f1 -d"," | sort'
  alias thesis='cd $repos/thesis'

  function preview {
    qlmanage -p $1 2> /dev/null
  }

  alias hyperjs='vim ~/dotfiles/hyper.js'
  alias chunkrc='vim ~/dotfiles/chunkwmrc'
  alias skhdrc='vim ~/dotfiles/skhdrc'
  alias ipythonrc='vim ~/dotfiles/jupyter/ipythonrc'
  alias rprofile='vim ~/dotfiles/Rprofile'
  alias pymolrc='vim ~/dotfiles/pymolrc'
  alias update_repos='cd $repos && sh update_repos.sh && cd -'
  alias ur='cd $repos && sh update_repos.sh && cd -'
  alias wr='$repos/wallpapers/random_wallpaper.sh'

fi

# remote {{{1

if ! [[ $PWD == *"tommason"* || $PWD == *"tmas0023"* ]]
then
  alias kill_subjobs="ps | grep subjobs.sh | awk '{print $1}' | xargs kill -9"  
fi

# everywhere {{{1 

alias bash_aliases='vim ~/.bash_aliases && source ~/.bashrc'
alias bash_functions='vim ~/.bash_functions && source ~/.bashrc'
alias bashrc='vim ~/.bashrc && source ~/.bashrc'
alias dotfiles='cd ~/dotfiles'
alias dots='cd ~/dotfiles'
alias shortcuts='cd ~/dotfiles/shortcuts'
alias lfrc='vim ~/.config/lf/lfrc'
alias rangerconf='vim ~/.config/ranger/rc.conf'
alias vimrc='vim ~/dotfiles/vimrc'

# aliases for default commands
alias c='clear'
alias l='ls'
alias ld='ls'
alias ll='ls -lh'
alias lsa='ls -a'
alias mkdir='mkdir -p'
alias s='source'
alias v='vim'

alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../..'
alias .....='cd ../../../..'


# plots everywhere
alias plotpcm="grep 'EMP2+EPCM' | tr -s [:blank:] | cut -d ' ' -f 3 | gnuplot -e \"set terminal dumb; plot '-' with lines notitle\""
alias plotmp2="grep 'E(MP2)' | sed '/NaN/d' | tr -s [:blank:] | cut -d ' ' -f 3 | gnuplot -e \"set terminal dumb; plot '-' with lines notitle\""
alias plotfmo="grep 'E corr MP2(2)=' | tr -s [:blank:] | cut -d ' ' -f 10 | gnuplot -e \"set terminal dumb; plot '-' with lines notitle\""
alias plotgauss="grep 'SCF Done' | tr -s [:blank:] | cut -d ' ' -f 6 | gnuplot -e \"set terminal dumb; plot '-' with lines notitle\""
alias plotfreqs="sed -n '/FREQ(CM\*\*-1)/,/^$/{//!p;}' | awk '{print $2,$NF}' | gnuplot -e \"set terminal dumb; plot '-' with lines notitle\""

# sort energies
alias sortmp2="grep 'E(MP2)' | tr -s [:blank:] | cut -d ' ' -f 3 | nl | sort -nr -k 2"

# total file size of all files from find command
alias total_filesize="xargs stat -c %s | awk '{total+=\$1} END {print total}'"

alias ra='ranger'
alias fm='lfcd'
alias vundle='git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim'

alias vim='vim -p' # automatically open in tabs
alias resize_vim='eval $(resize)' # if vim shows up small

# ssh
alias remote='sshpass -f ~/dotfiles/sshfile'
export raijin='tm3124@raijin.nci.org.au'
export magnus='tmason@magnus.pawsey.org.au'
export gaia='tmas0011@msgln6.its.monash.edu.au'
export m3='tmason1@m3.massive.org.au'
export monarch='tmason1@monarch.erc.monash.edu.au'
export stm='tmason@stampede2.tacc.utexas.edu'
export df="$HOME/dotfiles"

# files {{{1

alias oba='vim ~/.bash_aliases && source ~/.bashrc'
alias obf='vim ~/.bash_functions && source ~/.bashrc'
alias obp='vim ~/.bash_profile && source ~/.bashrc'
alias obr='vim ~/.bashrc && source ~/.bashrc'
alias oip='vim ~/dotfiles/jupyter/ipythonrc'
alias orp='vim ~/dotfiles/Rprofile'
alias otdc='vim ~/Documents/repos/daily_log/choline.md'
alias otdd='vim ~/Documents/repos/daily_log/dopamine.md'
alias otdm='vim ~/Documents/repos/daily_log/membranes.md'
alias otdp='vim ~/Documents/repos/daily_log/membranes.md'
alias ov='vim ~/dotfiles/vimrc'

# movement {{{1

alias ga='cd ~/monash_automation/'
alias gc='cd /home/tmason1/sn29_scratch/tmason1/hydrated_ils'
alias gd='cd /home/tmason1/sn29_scratch/tmason1/dopamine'
alias gq='cd /home/tmason1/sn29/apps/qcp'
alias gs='cd /home/tmason1/sn29_scratch/tmason1'
alias gw='cd /home/tmason1/sn29'