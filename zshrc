#!/usr/bin/env zsh

PS1="%F{cyan}%1d $%f %b"

HISTFILE=$HOME/.cache/zsh/history
HISTSIZE=10000 # per session
SAVEHIST=1000000 # in file

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^[e' edit-command-line

# Vi mode
bindkey -v
export KEYTIMEOUT=1
bindkey "^?" backward-delete-char # backspace fix

###################
#  Colourschemes  #
###################

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

source ~/dotfiles/colours.functions

colours(){
$(for func in $(print -l ${(ok)functions} | grep -v "^_\|colours")
  do 
  definition=$(type -f "$func")
  echo "$definition" | grep -lq "colorscheme" && echo "$func"
  done | fzf)
}
zle -N colours
bindkey '^[C' 'colours' # alt-shift-c

# Change cursor shape
# No blinking
# (https://invisible-island.net/xterm/ctlseqs/ctlseqs.html, search for 'CSI Ps SP q')
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[6 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    # zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[6 q"
}
zle -N zle-line-init

_fix_cursor(){
  echo -ne '\e[6 q' # Use beam shape cursor on startup.
}
# for each prompt
precmd_functions+=(_fix_cursor)

# tab through options
autoload -U compinit && compinit
zstyle ':completion:*' menu select

# set zsh window title
function set-title-precmd() {
  val="${PWD/#$HOME/~}"
  printf "\e]2;%s\a" "${val##*/}"
}

function set-title-preexec() {
  printf "\e]2;%s\a" "$1"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd set-title-precmd
add-zsh-hook preexec set-title-preexec

# Completion for kitty
kitty + complete setup zsh | source /dev/stdin

# start skhd on login
pgrep skhd >/dev/null || skhd -c ~/dotfiles/noyabai.skhdrc >/dev/null &

# fzf completion
source ~/.fzf.zsh

export EDITOR=nvim

export PYTHONPATH=$PYTHONPATH:/Users/tmas0023/pysimm
PATH=$PATH:/Users/tmas0023/pysimm/bin

PATH=$PATH:~/miniconda3/bin

###############
#  FUNCTIONS  #
###############

sc(){
$EDITOR $(find ~/.local/scripts -type f | grep -v '.git\|__pycache__' | fzf --preview='less {}')
}

esc(){
  $(find ~/.local/scripts -type f | grep -v '.git\|__pycache__' | fzf --preview='less {}')
}

termpdf(){
kitty @ kitten termpdf.py $(realpath $1)
}

xaringan_to_pdf() {
decktape remark --chrome-arg=--allow-file-access-from-files $1 ${1%.html}.pdf 
}

code_for_keynote() {
[[ "$#" -eq 0 ]] && echo "Syntax: code_for_keynote <filename>" && return 1
highlight -O rtf $1 --syntax python
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
  cat ${1:-/dev/stdin} | pbcopy
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

# Rectangle gaps (same as Spectacle but maintained)
rectangle_gaps(){
  [[ $# -eq 0 ]] && echo "Syntax: rectangle_gaps <gap in pixels>" && return 1
  defaults write com.knollsoft.Rectangle gapSize -float $1
}

lmp_run(){
  mpirun -np 2 $LAMMPS_MPI -i $1 >& out
}

gadiscp(){
  scp $gadi:"$1" .
}

vmd_unwrap () 
{ 
    echo "source ~/.local/scripts/chem/vmd_unwrap.tcl" >> unwrap_vmd.tmp
    [[ $USER == tommason ]] && vmd="/Applications/VMD 1.9.4a38.app/Contents/vmd/vmd_MACOSXX86_64"
    $vmd $1 $2 -e unwrap_vmd.tmp
    rm unwrap_vmd.tmp
}

#############
#  EXPORTS  #
#############

export GAMESS="$HOME/Documents/GAMESS/macos/rungms"
export LAMMPS_EXEC="$HOME/Documents/lammps-stable_29Oct2020/bin/lmp_mac"
export LAMMPS_MPI="$HOME/Documents/lammps-stable_29Oct2020/bin/lmp_mac_mpi"
export moltemplate_ff=/Volumes/GoogleDrive/My\ Drive/polymers/LAMMPS/moltemplate/moltemplate/force_fields

export filestream=/Volumes/GoogleDrive/My\ Drive
export pdfs=/Volumes/GoogleDrive/My\ Drive/zotero/pdfs
export repos="$HOME/Documents/repos"
export walls="$repos/wallpapers"
PATH="$repos/membranes/polymatic:$filestream/bin:$filestream/polymers/LAMMPS/fftool:$HOME/bin:/usr/local/bin:/usr/local/opt/make/libexec/gnubin:~/dotfiles/python_wrappers:/usr/local/texlive/2020/bin/x86_64-darwin:$PATH"
PATH="$repos/autochem/bin:$PATH"
PYTHONPATH="$repos/autochem:$PYTHONPATH"

# moltemplate
molpath="$HOME/Documents/moltemplate/moltemplate"
PATH="$molpath:$molpath/scripts:$PATH"

PYTHONPATH="$repos/dopamine/dopamine_analysis/elucidation_of_structure_in_c2mim_ac/analysis_organised:$PYTHONPATH"
PYTHONPATH="$HOME/.local/scripts/utils:$PYTHONPATH" # plottingfuncs
export automation="$repos/autochem"
if [[ $USER == "tommason" ]] 
then
  alias vmd="/Applications/VMD\ 1.9.4a38.app/Contents/vmd/vmd_MACOSXX86_64"
else
  # uni desktop
  alias vmd="/Applications/VMD\ 1.9.3.app/Contents/vmd/vmd_MACOSXX86"
fi
# gsed/ggrep on mac
export sed="gsed"
alias grep="grep --color"
alias ggrep="ggrep --color"
export grep='ggrep'
export settings="$HOME/Documents/repos/autochem/settings_files"

# ssh
export gadi='tm3124@gadi.nci.org.au'
export raijin='tm3124@raijin.nci.org.au'
export magnus='tmason@magnus.pawsey.org.au'
export gaia='tmas0011@msgln6.its.monash.edu.au'
export m3='tmason1@m3.massive.org.au'
export monarch='tmason1@monarch-login1.erc.monash.edu.au'
export mon='tmason1@monarch-login1.erc.monash.edu.au'
export stm='tmason@login3.stampede2.tacc.utexas.edu' # log in to same node to re-attach to tmux sessions
export df="$HOME/dotfiles"
export vault="tmason1@118.138.242.229"

# MD dirs
export opls="$HOME/.local/scripts/chem/lammps/create_opls_jobs"
export gaff="$HOME/.local/scripts/chem/lammps/create_gaff_jobs"

# IL MD scripts
PATH="$filestream/hydrated_ils/MD/peter_helper_scripts:$PATH"
export PATH="$(find "$HOME/.local/scripts" -type d | grep -v "^.$\|.git\|pycache" | tr '\n' ':' | sed 's/:$//'):$PATH"

source ~/dotfiles/lf/icons.sh

#############
#  aliases  #
#############
source ~/dotfiles/zsh.aliases
alias icat="kitty +kitten icat"
# weird terminal issue, can't clear terminal over ssh unless:
[[ "$TERM" == "xterm-kitty" ]] && alias ssh='kitty +kitten ssh' 
# but this stops the message of the day showing...
alias grep='grep --color'
alias jl='jupyter-lab'
alias ls='ls -G'
# alias scp='noglob scp' # travis [mol]-[mol] treated as regex
### open applications

alias ia="open -a /Applications/iA\ Writer.app/"
alias avo="open -a /Applications/Avogadro.app/"
alias iqmol="open -a /Applications/IQmol.app/"
alias deckset="open -a /Applications/Deckset.app/"
alias vl="$(find /usr/local/Cellar/vim -name 'less.sh')"
function ovito(){
  /Applications/Ovito.app/Contents/MacOS/ovito "$1" @
} # run as bg proc

# ssh
if [[ "$TERM" == "xterm-kitty" ]]; then
  alias gadi='kitty @ set-tab-title "Gadi" && ssh -Y $gadi; kitty @ set-tab-title "Local"'
  alias mon='kitty @ set-tab-title "Monarch" && ssh -Y $mon; kitty @ set-tab-title "Local"'
  alias m3='kitty @ set-tab-title "M3" && ssh -Y $m3; kitty @ set-tab-title "Local"'
  alias stm='kitty @ set-tab-title "Stampede" && ssh -Y $stm; kitty @ set-tab-title "Local"'
  alias vault='kitty @ set-tab-title "Vault" && ssh tmason1@118.138.242.229; kitty @ set-tab-title "Local"'
else
  alias gadi='ssh -Y $gadi'
  alias mon='ssh -Y $mon'
  alias m3='ssh -Y $m3'
  alias stm='ssh -Y $stm'
  alias vault='ssh tmason1@118.138.242.229'
fi

alias lammps_dir='cd ~/Documents/lammps-stable_29Oct2020'
alias gromacs_density='gromacs_get.sh npt.edr Density && gromacs_plot.sh npt_density.xvg'
alias lammps_density='echo density | lammps_plot.sh'

alias xelatex_fonts='fc-list : family | cut -f1 -d"," | sort'
alias feh='feh -F -d'

# gamess
alias gamess_docs='bat ~/Documents/GAMESS/gamess-standard-sept-2018/INPUT.DOC'
alias gamess_fmo='open /Users/tmas0023/Documents/GAMESS/gamess-standard-sept-2018/tools/fmo/annotated/FMO3-MP2.pdf'

alias kit="$EDITOR ~/.config/kitty/kitty.conf"
alias lfrc="$EDITOR ~/dotfiles/lf/lfrc.base && cd ~/dotfiles/shortcuts && ./make_shortcuts.sh && source ~/.zshrc; cd - > /dev/null"
alias vimrc="$EDITOR ~/dotfiles/vim/vimrc"
alias nvimrc="$EDITOR ~/dotfiles/vim/init.vim"
alias ybrc="$EDITOR ~/dotfiles/yabairc"
alias yabairc="$EDITOR ~/dotfiles/yabairc"
alias sprc="$EDITOR ~/dotfiles/spacebarrc"
alias spacerc="$EDITOR ~/dotfiles/spacebarrc"
alias skrc="$EDITOR ~/dotfiles/skhdrc"
alias skhdrc="$EDITOR ~/dotfiles/skhdrc"
alias zathurarc="$EDITOR ~/dotfiles/zathurarc"
alias ipythonrc="$EDITOR ~/dotfiles/jupyter/ipythonrc"
alias rprofile="$EDITOR ~/dotfiles/Rprofile"
alias pymolrc="$EDITOR ~/dotfiles/pymolrc"
alias ur='cd $repos && sh miscellaneous/update_repos.sh && cd -'
alias wr='$repos/wallpapers/random_wallpaper.sh >& /dev/null'

# window management
alias yb='brew services start yabai && brew services start spacebar'
alias ybr='brew services restart yabai && brew services restart spacebar'
alias ybs='brew services stop yabai && brew services stop spacebar' 

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
alias v="$EDITOR" # vim or neovim
alias vim="$EDITOR" # vim or neovim
alias pr='preview'
alias fenv='env | fzf'
alias fbase='eval $(alias | grep base16 | awk -F"=" '\''{print $1}'\'' | fzf)'
alias fvim='fzf -m --print0 | xargs -0 -o $EDITOR -p' # multiple files possible
alias fopen='fzf --print0 | xargs -0 -o open'
alias ffinder='fzf --print0 | xargs -0 open -R'
alias fpr='fzf --print0 | xargs -0 -o preview'
alias fman='fd \.1$ /usr/share/man | fzf | xargs -o man'
alias fexecute='eval $(history | awk '\''{$1=""; print $0}'\'' | sort | uniq | fzf)' 
# ctrl-h 
bindkey -s '^H' 'fman\n'


# git
alias g='git'
alias gc='git clone'

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

# alt-l to open lf
bindkey -s '^[l' 'lfcd\n'
alias fm='lfcd'

alias today="$EDITOR $repos/notes/today.md"
alias weather="curl wttr.in/Melbourne\?0"
# Syntax highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# i.e $LAM normally black before typing $LAMMPS_EXEC, and not visible
ZSH_HIGHLIGHT_STYLES[comment]='fg=cyan' # fixed now

################################
#  Run pfetch on new instance  #
################################
export PF_INFO="ascii title os host shell editor memory"
pfetch

# editing shortcuts
alias osh="cd ~/dotfiles/shortcuts; ls * | fzf | xargs -o $EDITOR; ./make_shortcuts.sh; cd - > /dev/null"

################
#  Ambertools  #
################

[[ $USER == tmas0023 ]] && export PATH="$PATH:/Users/tmas0023/miniconda3/bin"

###############
#  SHORTCUTS  #
###############

# files

alias oba='vim ~/dotfiles/aliases/aliases.base && cd ~/dotfiles/shortcuts && ./make_shortcuts.sh && source ~/.bashrc; cd - > /dev/null'
alias obf='vim ~/.bash_functions; [[ ! $USER =~ (tmas0023|tommason) ]] && source ~/.bashrc'
alias obp='vim ~/.bash_profile; [[ ! $USER =~ (tmas0023|tommason) ]] && source ~/.bashrc'
alias obr='vim ~/.bashrc; [[ ! $USER =~ (tmas0023|tommason) ]] && source ~/.bashrc'
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
alias gchm='cd ~/Documents/repos/hydrated_ils/hydrated_il_MD'
alias gchp='cd ~/Documents/repos/hydrated_ils/hydrated_il_paper/aug_19/submission/submission/submission_jun20'
alias gcm='cd /Volumes/GoogleDrive/My\ Drive/chm3911/assignment_info/files'
alias gco='cd ~/.config/'
alias gda='cd ~/Documents/repos/dopamine/dopamine_analysis'
alias gdc='cd ~/Documents'
alias gdf='cd ~/dotfiles'
alias gdk='cd ~/Desktop'
alias gdl='cd ~/Documents/repos/daily_log'
alias gdm='cd ~/Documents/repos/dopamine/supramolecular_aggregation_MD'
alias gdp='cd ~/Documents/repos/dopamine/dopamine_colour_paper'
alias gdr='cd ~/Dropbox'
alias gdw='cd ~/Downloads'
alias gfd='cd /Volumes/GoogleDrive/My\ Drive/Dopamine'
alias gfm='cd /Volumes/GoogleDrive/My\ Drive/meetings'
alias gfo='cd /Volumes/GoogleDrive/My\ Drive'
alias gfpd='cd /Volumes/GoogleDrive/My\ Drive/zotero/pdfs'
alias gfpo='cd /Volumes/GoogleDrive/My\ Drive/polymers'
alias gkc='cd ~/.config/kitty'
alias gkij='cd /Volumes/GoogleDrive/My\ Drive/backups/gadi/hydrated_ils/molecular_dynamics/pieda/8IP/c2mim-ac/anion-centred'
alias gmc='cd ~/Documents/repos/mccg'
alias gmm='cd ~/Documents/repos/membranes'
alias gmo='cd ~/Movies'
alias gpc='cd ~/Pictures'
alias gq='cd ~/Documents/repos/qcp'
alias gri='cd ~/Documents/repos/ideas'
alias grm='cd ~/Documents/repos/membranes'
alias grp='cd ~/Documents/repos'
alias gsc='cd ~/.local/scripts'
alias gsh='cd ~/dotfiles/shortcuts'
alias gsu='cd ~/Documents/repos/dopamine/dopamine_paper/supp_info'
alias gta='cd ~/Documents/repos/talks/confirmation_talk'
alias gte='cd ~/Documents/repos/templates'
alias gth='cd ~/Documents/repos/thesis'
alias gtm='cd ~/tmp'
alias gw='cd ~/Documents/repos/wallpapers'
