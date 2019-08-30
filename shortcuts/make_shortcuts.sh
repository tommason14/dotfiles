#!/usr/bin/env bash

declare -A conversion
conversion["mgs"]="magnus"
conversion["rjn"]="raijin"
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
  sed '/^mas/d' |\
  sed '/^mon/d' |\
  sed '/^stm/d'
}

clean(){
  rm_comments |\
  delete_blanks |\
  rm_supercomps
}


make_supercomp_configs(){
  scheduler=$1 # slurm or pbs
  supercomps=${@:2} 
  for f in $supercomps
  do
    long_hostname=${conversion[$f]}
    cp ../lf/lfrc.base.$scheduler ../lf/lfrc.$long_hostname
    printf "\n# Files {{{2\n\n" >> ../lf/lfrc.$long_hostname
    cat files | sort | clean | sed -e 's/^/map o/' -e 's/:/ $vim/' >> ../lf/lfrc.$long_hostname
    printf "\n# Movement {{{2\n\n" >> ../lf/lfrc.$long_hostname
    cat folders | sort | delete_blanks | rm_comments | sed -n "/$f-/p" |\
    sed -e "s/^$f-/map g/" -e 's/:/ cd/' >> ../lf/lfrc.$long_hostname
    cp ../aliases/aliases.base ../aliases/aliases.$long_hostname
    printf "\n# files {{{1\n\n" >> ../aliases/aliases.$long_hostname
    cat files | sort | clean | sed -e 's/^/alias o/' -e "s/:/='vim/" -e "s/$/'/" >> ../aliases/aliases.$long_hostname
    printf "\n# movement {{{1\n\n" >> ../aliases/aliases.$long_hostname
    cat folders | sort | delete_blanks | rm_comments | sed -n "/$f-/p" |\
    sed -e "s/^$f-/alias g/" -e "s/:/='cd/" -e "s/$/'/" >> ../aliases/aliases.$long_hostname
  done
}

make_local_configs(){
  for f in $@
  do
    long_hostname=${conversion[$f]}
    cp ../lf/lfrc.base.local ../lf/lfrc.$long_hostname
    printf "\n# Files {{{2\n\n" >> ../lf/lfrc.$long_hostname
    cat files | sort | clean  | sed -e 's/^/map o/' -e 's/:/ $vim/' >> ../lf/lfrc.$long_hostname
    printf "\n# Movement {{{2\n\n" >> ../lf/lfrc.$long_hostname
    cat folders | sort | clean | sed 's/^/map g/;s/:/ cd/' >> ../lf/lfrc.$long_hostname
    cp ../aliases/aliases.base ../aliases/aliases.$long_hostname
    printf "\n# files {{{1\n\n" >> ../aliases/aliases.$long_hostname
    cat files | sort | clean | sed -e 's/^/alias o/' -e "s/:/='vim/" -e "s/$/'/" >> ../aliases/aliases.$long_hostname
    printf "\n# movement {{{1\n\n" >> ../aliases/aliases.$long_hostname
    cat folders | sort | clean | sed -e 's/^/alias g/' -e "s/:/='cd/" -e "s/$/'/" >> ../aliases/aliases.$long_hostname
done 
}

make_bash_aliases(){
  printf "\n# Files {{{2\n\n" > bash_aliases
  cat files | sort | clean | sed -e 's/^/alias o/' -e "s/:/='vim/" -e "s/$/'/" >> bash_aliases
  printf "\n# Movement {{{2\n\n" >> bash_aliases
  cat folders | sort | clean | sed -e 's/^/alias g/' -e "s/:/='cd/" -e "s/$/'/" >> bash_aliases
}

main(){
  locals="uni home"
  slurm="mgs mas mon stm"
  pbs="rjn"
  make_local_configs ${locals[@]}
  make_supercomp_configs 'slurm' ${slurm[@]}
  make_supercomp_configs 'pbs' ${pbs[@]}
}

main