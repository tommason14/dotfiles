#!/usr/bin/env bash

SHORTCUTS="$HOME/dotfiles/shortcuts"
DOTS="$HOME/dotfiles"

declare -A conversion
conversion["mgs"]="magnus"
conversion["rjn"]="raijin"
conversion["gadi"]="gadi"
conversion["mon"]="monarch"
conversion["mas"]="m3"
conversion["stm"]="stampede"
conversion["uni"]="MU00151959X"
conversion["home"]="macbook"

rm_comments(){
  sed '/^#/d'
}

delete_blanks(){
  sed '/^$/d'
}

rm_supercomps(){
  sed '/^mgs/d' |\
  sed '/^rjn/d' |\
  sed '/^gadi/d' |\
  sed '/^mas/d' |\
  sed '/^mon/d' |\
  sed '/^stm/d'
}

clean(){
  rm_comments |\
  delete_blanks |\
  rm_supercomps
}


make_configs(){
  platform=$1 # local, slurm or pbs
  machines=${@:2} 
  for f in $machines
  do
    long_hostname=${conversion[$f]}
    # mac files/folders labelled as mac-au or mac-gbmo
    [ $f = "uni" ] || [ $f = "home" ] && f='mac' 
    cp $DOTS/lf/lfrc.base.$platform $DOTS/lf/lfrc.$long_hostname
    printf "\n# Files {{{2\n\n" >> $DOTS/lf/lfrc.$long_hostname
    cat $SHORTCUTS/files | sort | clean | sed -e 's/^/map o/' -e 's/:/ $vim/' >> $DOTS/lf/lfrc.$long_hostname
    printf "\n# Movement {{{2\n\n" >> $DOTS/lf/lfrc.$long_hostname
    cat $SHORTCUTS/folders | sort | delete_blanks | rm_comments | sed -n "/$f-/p" |\
    sed -e "s/^$f-/map g/" -e 's/:/ cd/' >> $DOTS/lf/lfrc.$long_hostname
    cp $DOTS/aliases/aliases.base $DOTS/aliases/aliases.$long_hostname
    printf "\n# files {{{1\n\n" >> $DOTS/aliases/aliases.$long_hostname
    cat $SHORTCUTS/files | sort | clean | sed -e 's/^/alias o/' -e "s/:/='vim/" -e "s/$/'/" >> $DOTS/aliases/aliases.$long_hostname
    printf "\n# movement {{{1\n\n" >> $DOTS/aliases/aliases.$long_hostname
    cat $SHORTCUTS/folders | sort | delete_blanks | rm_comments | sed -n "/$f-/p" |\
    sed -e "s/^$f-/alias g/" -e "s/:/='cd/" -e "s/$/'/" >> $DOTS/aliases/aliases.$long_hostname
  done
}

main(){
  locals="uni home"
  slurm="mgs mas mon stm"
  pbs="rjn gadi"
  make_configs 'local' ${locals[@]}
  make_configs 'slurm' ${slurm[@]}
  make_configs 'pbs' ${pbs[@]}
}

main
