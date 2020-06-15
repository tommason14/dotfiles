#!/usr/bin/env zsh

PS1="%F{blue}%1d $%f "

HISTFILE=$HOME/.cache/zsh/history

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^[e' edit-command-line

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
export PAGER=bat

###############
#  FUNCTIONS  #
###############

sc(){
find ~/.local/scripts -type f | grep -v '.git\|pycache' | fzf --preview='less {}'| xargs -o $EDITOR
}

xaringan_to_pdf() {
decktape remark --chrome-arg=--allow-file-access-from-files $1 ${1%.html}.pdf 
}

pymol(){ 
/Applications/PyMOL.app/Contents/MacOS/PyMOL $@ -d "@~/.pymolrc"
}

wl(){
[[ "$#" -eq 0 ]] && echo "Syntax: wl wallpaper_file options" && return 1
$HOME/Documents/repos/wallpapers/make_wallpaper.sh "$@"
}

gitall() {
  git pull # just in case
  git add .
  git commit
  git push
}

mkcd() {
  mkdir -p $1 
  cd $1
}

copy() {
  cat $1 | pbcopy
}

lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [[ -f "$tmp" ]]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [[ -d "$dir" ]]; then
            if [[ "$dir" != "$(pwd)" ]]; then
                cd "$dir"
            fi
        fi
    fi
}

#############
#  EXPORTS  #
#############

[[ $USER == "tommason" ]] && export LAMMPS_EXEC="/usr/local/bin/lmp_serial" # pysimm, no fourier dihedrals tho
[[ $USER == "tmas0023" ]] && export LAMMPS_EXEC="/Users/tmas0023/Documents/lammps-3Mar20/src/lmp_mac" # compiled

export filestream="/Volumes/GoogleDrive/My Drive"
export repos="$HOME/Documents/repos"
export walls="$repos/wallpapers"
PATH="$repos/membranes/polymatic:$filestream/bin:$filestream/polymers/LAMMPS/fftool:~/bin:/usr/local/opt/make/libexec/gnubin:~/dotfiles/python_wrappers:/usr/local/texlive/2018/bin/x86_64-darwin:$PATH"
PATH="$repos/autochem/bin:$PATH"
export PYTHONPATH="$repos/autochem/:$repos/dopamine/dopamine_analysis/elucidation_of_structure_in_c2mim_ac/analysis_organised:$PYTHONPATH"
export automation="$repos/autochem"
if [[ $HOSTNAME == *"MBP"* ]] 
then
  alias vmd='/Applications/VMD\ 1.9.4a38.app/Contents/vmd/vmd_MACOSXX86_64'
else
  # uni desktop
  alias vmd='/Applications/VMD\ 1.9.3.app/Contents/vmd/vmd_MACOSXX86'
fi
# gsed/ggrep on mac
export sed='gsed'
export grep='ggrep'
export settings="$HOME/Documents/repos/monash_automation/settings_files"
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

export PATH="$(find "$HOME/.local/scripts" -type d | grep -v "^.$\|.git" | tr '\n' ':' | sed 's/:$//'):$PATH"

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

#############
#  aliases  #
#############

alias grep='grep --color'
alias jl='jupyter-lab'
alias ls='ls -G'
### open applications

alias ia="open -a /Applications/iA\ Writer.app/"
alias avo="open -a /Applications/Avogadro.app/"
alias iqmol="open -a /Applications/IQmol.app/"
alias deckset="open -a /Applications/Deckset.app/"
alias vl="$(find /usr/local/Cellar/vim -name 'less.sh')"

# monash
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

alias feh='feh -F -d'

alias lfrc="vim ~/dotfiles/lf/lfrc.base && cd ~/dotfiles/shortcuts && ./make_shortcuts.sh && source ~/.zshrc; cd - > /dev/null"
alias hyperjs='vim ~/dotfiles/hyper.js'
alias ybrc='vim ~/dotfiles/yabairc'
alias yabairc='vim ~/dotfiles/yabairc'
alias sprc='vim ~/dotfiles/spacebarrc'
alias spacerc='vim ~/dotfiles/spacebarrc'
alias skrc='vim ~/dotfiles/skhdrc'
alias skhdrc='vim ~/dotfiles/skhdrc'
alias ipythonrc='vim ~/dotfiles/jupyter/ipythonrc'
alias rprofile='vim ~/dotfiles/Rprofile'
alias pymolrc='vim ~/dotfiles/pymolrc'
alias ur='cd $repos && sh miscellaneous/update_repos.sh && cd -'
alias wr='$repos/wallpapers/random_wallpaper.sh'

# window management
alias yb='brew services start yabai && brew services start skhd && brew services start spacebar'
alias ybr='brew services restart yabai && brew services restart skhd & brew services restart spacebar'
alias ybs='brew services stop yabai && brew services stop skhd && brew services stop spacebar' 

# aliases for default commands
alias c='clear'
alias i='less -i'
alias less='less -R'
alias l='ls'
alias ld='ls'
alias ll='ls -lh'
alias lsa='ls -a'
alias mkdir='mkdir -p'
alias s='source'
alias v='vim'
alias pr='preview'

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

alias vim='vim -p' # automatically open in tabs
alias fm='eval $(resize) && lfcd'
# alt-l to open lf
bindkey -s '^[l' 'lfcd\n'


# Syntax highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

###############
#  SHORTCUTS  #
###############

# files

alias oba='vim ~/dotfiles/aliases/aliases.base && cd ~/dotfiles/shortcuts && ./make_shortcuts.sh && source ~/.bashrc; cd - > /dev/null'
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
alias ovrc='vim ~/dotfiles/vimrc'
alias ozh='vim ~/.zshrc && source ~/.zshrc'

# movement

alias gau='cd ~/Documents/repos/autochem'
alias gbch='cd /Volumes/GoogleDrive/My\ Drive/hydrated_ILs'
alias gbg='cd /Volumes/GoogleDrive/My\ Drive/backups/gadi'
alias gbk='cd /Volumes/GoogleDrive/My\ Drive/backups'
alias gbm3='cd /Volumes/GoogleDrive/My\ Drive/backups/m3'
alias gbma='cd /Volumes/GoogleDrive/My\ Drive/backups/magnus'
alias gbmo='cd /Volumes/GoogleDrive/My\ Drive/backups/monarch'
alias gbr='cd /Volumes/GoogleDrive/My\ Drive/backups/raijin'
alias gbs='cd /Volumes/GoogleDrive/My\ Drive/backups/stampede'
alias gcha='cd ~/Documents/repos/hydrated_ils/hydrated_il_analysis'
alias gchp='cd ~/Documents/repos/hydrated_ils/hydrated_il_paper/aug_19'
alias gcm='cd /Volumes/GoogleDrive/My\ Drive/chm3911/assignment_info/files'
alias gcs='cd ~/Documents/repos/chem_scripts'
alias gda='cd ~/Documents/repos/dopamine/dopamine_analysis'
alias gdc='cd ~/Documents'
alias gdf='cd ~/dotfiles'
alias gdk='cd ~/Desktop'
alias gdl='cd ~/Documents/repos/daily_log'
alias gdp='cd ~/Documents/repos/dopamine/dopamine_colour_paper'
alias gdr='cd ~/Dropbox'
alias gdw='cd ~/Downloads'
alias gfd='cd /Volumes/GoogleDrive/My\ Drive/Dopamine'
alias gfo='cd /Volumes/GoogleDrive/My\ Drive'
alias gfpd='cd /Volumes/GoogleDrive/My\ Drive/zotero/pdfs'
alias gfpo='cd /Volumes/GoogleDrive/My\ Drive/polymers'
alias gkij='cd /Volumes/GoogleDrive/My\ Drive/backups/gadi/hydrated_ils/molecular_dynamics/ch_ac/clusters/cluster-0'
alias gmc='cd ~/Documents/repos/mccg'
alias gmm='cd ~/Documents/repos/membranes'
alias gmo='cd ~/Movies'
alias gpc='cd ~/Pictures'
alias gq='cd ~/Documents/repos/qcp'
alias grm='cd ~/Documents/repos/membranes'
alias grp='cd ~/Documents/repos'
alias gsc='cd ~/.local/scripts'
alias gsu='cd ~/Documents/repos/dopamine/dopamine_paper/supp_info'
alias gta='cd ~/Documents/repos/talks/confirmation_talk'
alias gte='cd ~/Documents/repos/templates'
alias gth='cd ~/Documents/repos/thesis'
alias gtm='cd ~/tmp'
alias gw='cd ~/Documents/repos/wallpapers'
