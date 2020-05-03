#!/usr/bin/env sh
# prompt {{{1

CYAN='\[\e[0;36m\]'
NO_COLOUR='\[\e[0m\]'
DATE=$(date '+%d/%m')
if [[ $USER =~ (tommason|tmas0023) ]]; then
  export PS1="${CYAN}${DATE} Local \W \$ ${NO_COLOUR}"
elif [[ $HOSTNAME == *"stampede2.tacc.utexas.edu" ]]; then
  export PS1="[${DATE} Stampede \W \$] "
else
  export PS1="[${DATE} \h \W \$] "
fi

# uni mac or macbook {{{1

if [[ $PWD == *"tmas0023"* || $PWD == *"tommason"* || $PWD == *"/Volumes/GoogleDrive"* ]]; then
    export LAMMPS_EXEC="/usr/local/bin/lmp_serial" # pysimm
    export filestream="/Volumes/GoogleDrive/My Drive"
    export repos="$HOME/Documents/repos"
    export PATH=$repos/chem_scripts:$repos/membranes/polymatic:"$filestream"/bin:"$filestream"/polymers/LAMMPS/fftool:~/bin:/usr/local/opt/make/libexec/gnubin:~/dotfiles/python_wrappers:/usr/local/texlive/2018/bin/x86_64-darwin:$PATH
    # export PATH="$repos/monash_automation/bin:$PATH"
    # export PYTHONPATH="$repos/monash_automation/:$PYTHONPATH"
    alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
    alias automation="cd $repos/monash_automation"
    export automation="$repos/monash_automation"
    if [[ $HOSTNAME == *"MBP"* ]] 
    then
      alias vmd='/Applications/VMD\ 1.9.4a38.app/Contents/vmd/vmd_MACOSXX86_64'
    else
      # uni desktop
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
    # export PATH=~/chem_scripts:~/monash_automation/:$PATH
    # export PYTHONPATH=~/monash_automation:$PYTHONPATH
    alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"' 
    alias job_count='squeue | grep tmason1 | wc -l'
    alias automation='cd ~/monash_automation'
fi

# gaia {{{1

if [[ $PWD == *"nfs"* ]]; then
    alias ranger='python3 ~/ranger/ranger.py --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"' 
fi

# local {{{1

[[ $USER == "tommason" ]] && shopt -s direxpand

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

  # monash
  # alias gadi='sshpass -f ~/dotfiles/sshfile ssh -XY tm3124@gadi-login-01.nci.org.au'
  alias gadi='sshpass -f ~/dotfiles/sshfile ssh -XY tm3124@gadi.nci.org.au'
  alias raijin='sshpass -f ~/dotfiles/sshfile ssh -XY tm3124@raijin.nci.org.au'
  alias magnus='sshpass -f ~/dotfiles/sshfile ssh -Y tmason@magnus.pawsey.org.au'
  alias gaia='sshpass -f ~/dotfiles/sshfile ssh -Y -t tmas0011@msgln6.its.monash.edu.au "cd /nfs/shares/pas-grp/TOM; bash"'
  alias m3='sshpass -f ~/dotfiles/sshfile ssh -Y tmason1@m3.massive.org.au'
  alias monarch='sshpass -f ~/dotfiles/sshfile ssh -Y tmason1@monarch.erc.monash.edu.au'
  alias stampede='~/dotfiles/sshstam'
  alias vault='sshpass -f ~/dotfiles/sshfile ssh tmason1@118.138.242.229'
  alias chem06="ssh -XY chem06@monarch.erc.monash.edu"
  alias qcp='python3 ~/Google_Drive/Scripts/qcp/qcp/__main__.py'
  alias lammps_dir='cd /usr/local/share/lammps'

  alias size='du -sh'
  alias xelatex_fonts='fc-list : family | cut -f1 -d"," | sort'
  alias thesis='cd $repos/thesis'

  alias feh='feh -F -d'
  function preview {
    qlmanage -p $1 2> /dev/null
  }

  alias hyperjs='vim ~/dotfiles/hyper.js'
  alias yabairc='vim ~/dotfiles/yabairc'
  alias skhdrc='vim ~/dotfiles/skhdrc'
  alias ipythonrc='vim ~/dotfiles/jupyter/ipythonrc'
  alias rprofile='vim ~/dotfiles/Rprofile'
  alias pymolrc='vim ~/dotfiles/pymolrc'
  alias update_repos='cd $repos && sh update_repos.sh && cd -'
  alias ur='cd $repos && sh miscellaneous/update_repos.sh && cd -'
  alias wr='$repos/wallpapers/random_wallpaper.sh'
  export walls="$repos/wallpapers"

  # window management
  alias yb='brew services start yabai && brew services start skhd'
  alias ybr='brew services restart yabai && brew services restart skhd'
  alias ybs='brew services stop yabai && brew services stop skhd'
 
  export LF_ICONS="\
di=:\
fi=:\
ln=:\
or=:\
ex=:\
*.c=:\
*.cc=:\
*.clj=:\
*.coffee=:\
*.cpp=:\
*.css=:\
*.d=:\
*.dart=:\
*.erl=:\
*.exs=:\
*.fs=:\
*.go=:\
*.h=:\
*.hh=:\
*.hpp=:\
*.hs=:\
*.html=:\
*.java=:\
*.jl=:\
*.js=:\
*.json=:\
*.lua=:\
*.md=:\
*.php=:\
*.pl=:\
*.pro=:\
*.py=:\
*.rb=:\
*.rs=:\
*.scala=:\
*.ts=:\
*.vim=:\
*.cmd=:\
*.ps1=:\
*.sh=:\
*.bash=:\
*.zsh=:\
*.fish=:\
*.tar=:\
*.tgz=:\
*.arc=:\
*.arj=:\
*.taz=:\
*.lha=:\
*.lz4=:\
*.lzh=:\
*.lzma=:\
*.tlz=:\
*.txz=:\
*.tzo=:\
*.t7z=:\
*.zip=:\
*.z=:\
*.dz=:\
*.gz=:\
*.lrz=:\
*.lz=:\
*.lzo=:\
*.xz=:\
*.zst=:\
*.tzst=:\
*.bz2=:\
*.bz=:\
*.tbz=:\
*.tbz2=:\
*.tz=:\
*.deb=:\
*.rpm=:\
*.jar=:\
*.war=:\
*.ear=:\
*.sar=:\
*.rar=:\
*.alz=:\
*.ace=:\
*.zoo=:\
*.cpio=:\
*.7z=:\
*.rz=:\
*.cab=:\
*.wim=:\
*.swm=:\
*.dwm=:\
*.esd=:\
*.jpg=:\
*.jpeg=:\
*.mjpg=:\
*.mjpeg=:\
*.gif=:\
*.bmp=:\
*.pbm=:\
*.pgm=:\
*.png=:\
*.ppm=:\
*.pse=:\
*.tga=:\
*.xbm=:\
*.xpm=:\
*.tif=:\
*.tiff=:\
*.png=:\
*.svg=:\
*.svgz=:\
*.mng=:\
*.pcx=:\
*.mov=:\
*.mpg=:\
*.mpeg=:\
*.m2v=:\
*.mkv=:\
*.webm=:\
*.ogm=:\
*.mp4=:\
*.m4v=:\
*.mp4v=:\
*.vob=:\
*.qt=:\
*.nuv=:\
*.wmv=:\
*.asf=:\
*.rm=:\
*.rmvb=:\
*.flc=:\
*.avi=:\
*.fli=:\
*.flv=:\
*.gl=:\
*.dl=:\
*.xcf=:\
*.xwd=:\
*.yuv=:\
*.cgm=:\
*.emf=:\
*.ogv=:\
*.ogx=:\
*.aac=:\
*.au=:\
*.flac=:\
*.m4a=:\
*.mid=:\
*.midi=:\
*.mka=:\
*.mp3=:\
*.mpc=:\
*.ogg=:\
*.ra=:\
*.wav=:\
*.oga=:\
*.opus=:\
*.spx=:\
*.xspf=:\
*.pdf=:\
*.nix=:\
" 

fi

# remote {{{1

if ! [[ $PWD == *"tommason"* || $PWD == *"tmas0023"* ]]
then
  alias kill_subjobs="ps | grep subjobs.sh | awk '{print $1}' | xargs kill -9"  
  alias remove_orca_temps="ls -1 | sed '/inp/d;/job/d;/log/d;/xyz/d' | xargs rm"
fi

# everywhere {{{1 

alias bash_aliases='vim ~/.bash_aliases && source ~/.bashrc'
alias bash_functions='vim ~/.bash_functions && source ~/.bashrc'
alias bashrc='vim ~/.bashrc && source ~/.bashrc'
alias dotfiles='cd ~/dotfiles'
alias dots='cd ~/dotfiles'
alias shortcuts='cd ~/dotfiles/shortcuts'
# lfrc is different for slurm/pbs/local
if [[ $USER =~ (tommason|tmas0023) ]]; then
  lf_conf="~/dotfiles/lf/lfrc.base.local"
elif [[ $USER =~ "tmason" ]]; then
  lf_conf="~/dotfiles/lf/lfrc.base.slurm"
else
  lf_conf="~/dotfiles/lf/lfrc.base.pbs"
fi
alias lfrc="vim $lf_conf && cd ~/dotfiles/shortcuts && ./make_shortcuts.sh && source ~/.bashrc && cd - > /dev/null"
alias rangerconf='vim ~/.config/ranger/rc.conf'
alias vimrc='vim ~/dotfiles/vimrc'

# aliases for default commands
alias c='clear'
alias i='less -i'
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

# chem assist

chem_assist_ds() {
settings_file=$(ls *.py | sort | head -n 1)
chem_assist -ds $settings_file
[[ -d __pycache__ ]] && rm -r __pycache__
}

alias cad='chem_assist_ds'
alias cae='chem_assist -e'
alias car='chem_assist -r'

if [[ $USER =~ (tmason|tm3124) ]] 
then
  export settings="$HOME/monash_automation/settings_files" # remotes
else
  export settings="$HOME/Documents/repos/monash_automation/settings_files"
fi

# plots everywhere
alias lastcol="awk '{print \$NF}'"
alias plotgnu="gnuplot -e \"set terminal dumb; plot '-' with lines notitle\""
alias plotpcm="grep 'EMP2+EPCM' | tr -s [:blank:] | cut -d ' ' -f 3 | gnuplot -e \"set terminal dumb; plot '-' with lines notitle\""
alias plotmp2="grep 'E(MP2)' | sed '/NaN/d' | tr -s [:blank:] | cut -d ' ' -f 3 | gnuplot -e \"set terminal dumb; plot '-' with lines notitle\""
alias plotfmo="grep 'E corr MP2(2)=' | tr -s [:blank:] | cut -d ' ' -f 10 | gnuplot -e \"set terminal dumb; plot '-' with lines notitle\""
alias plotgauss="grep 'SCF Done' | tr -s [:blank:] | cut -d ' ' -f 6 | gnuplot -e \"set terminal dumb; plot '-' with lines notitle\""
alias plotgamessfreqs="sed -n '/FREQ(CM\*\*-1)/,/^$/{//!p;}' | awk '{print $2,$NF}' | gnuplot -e \"set terminal dumb; plot '-' with lines notitle\""
alias plotgaussfreqs="tee >(grep Frequencies | awk '{OFS=\"\n\"; print $3,$4,$5}' > fone) >(grep 'IR Inten' | awk '{OFS=\"\n\"; print $4,$5,$6}' > ftwo ) &> /dev/null && paste fone ftwo | gnuplot -e \"set terminal dumb; plot '-' with lines notitle\" && rm fone ftwo"
alias plotrmsgamess='grep "R.M.S.=" | lastcol | plotgnu'
alias plotrmsgauss='grep "Internal  Forces" | lastcol | plotgnu'

# sort energies
alias sortmp2="grep 'E(MP2)' | tr -s [:blank:] | cut -d ' ' -f 3 | nl | sort -nr -k 2"

# total file size of all files from find command
alias total_filesize="xargs stat -c %s | awk '{total+=\$1} END {print total}'"

alias ra='ranger'
alias fm='eval $(resize) && lfcd'
alias vundle='git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim'

alias vim='vim -p' # automatically open in tabs
alias resize_vim='eval $(resize)' # if vim shows up small

# ssh
alias remote='sshpass -f ~/dotfiles/sshfile'
export gadi='tm3124@gadi.nci.org.au'
export raijin='tm3124@raijin.nci.org.au'
export magnus='tmason@magnus.pawsey.org.au'
export gaia='tmas0011@msgln6.its.monash.edu.au'
export m3='tmason1@m3.massive.org.au'
export monarch='tmason1@monarch.erc.monash.edu.au'
export stm='tmason@stampede2.tacc.utexas.edu'
export df="$HOME/dotfiles"
export vault="tmason1@118.138.242.229"

# files {{{1

alias oba='vim ~/dotfiles/aliases/aliases.base && cd ~/dotfiles/shortcuts && ./make_shortcuts.sh && source ~/.bashrc && cd - > /dev/null'
alias obf='vim ~/.bash_functions && source ~/.bashrc'
alias obp='vim ~/.bash_profile && source ~/.bashrc'
alias obr='vim ~/.bashrc && source ~/.bashrc'
alias oip='vim ~/dotfiles/jupyter/ipythonrc'
alias orp='vim ~/dotfiles/Rprofile'
alias otdc='vim ~/Documents/repos/daily_log/choline.md'
alias otdd='vim ~/Documents/repos/daily_log/dopamine.md'
alias otdj='vim ~/Documents/repos/daily_log/subd_jobs.md'
alias otdm='vim ~/Documents/repos/daily_log/membranes.md'
alias otdp='vim ~/Documents/repos/daily_log/membranes.md'
alias ovi='vim ~/dotfiles/vimrc'

# movement {{{1

alias gau='cd ~/monash_automation/'
alias gch='cd /home/tmason1/sn29_scratch/tmason1/hydrated_ils'
alias gd='cd /home/tmason1/sn29_scratch/tmason1/dopamine'
alias gdf='cd ~/dotfiles'
alias gp='cd /home/tmason1/sn29_scratch/tmason1/polymers'
alias gq='cd /home/tmason1/sn29/apps/qcp'
alias gs='cd /home/tmason1/sn29_scratch/tmason1'
alias gt='cd /home/tmason1/sn29_scratch/tmason1/tests'
alias gw='cd /home/tmason1/sn29'
