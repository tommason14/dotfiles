#!/usr/bin/env bash

rm_comments(){
  sed '/^#/d'
}

delete_blanks(){
  sed '/^$/d'
}

rm_supercomps(){
  sed '/mgs/d' |\
  sed '/rjn/d' |\
  sed '/mas/d' |\
  sed '/mon/d' |\
  sed '/stm/d'
}

clean(){
  rm_comments |\
 delete_blanks |\
  rm_supercomps
}

declare -A conversion
conversion["mgs"]="magnus"
conversion["rjn"]="raijin"
conversion["mon"]="monarch"
conversion["mas"]="m3"
conversion["stm"]="stampede"
conversion["uni"]="MU00151959X"
conversion["home"]="macbook"

make_supercomp_configs(){
scheduler=$1 # slurm or pbs (or local)
supercomps=${@:2} 
for f in $supercomps
do
  long_hostname=${conversion[$f]}
  cp ../lf/lfrc.base.$scheduler lf.automated.$long_hostname
  printf "\n# files {{{2\n\n" >> lf.automated.$long_hostname
  cat files | sort | clean | sed -e 's/^/map o/' -e 's/:/ $vim/' >> lf.automated.$long_hostname
  printf "\n# movement {{{2\n\n" >> lf.automated.$long_hostname
  cat folders |\
  sort |\
  delete_blanks |\
  rm_comments |\
  sed -n "/$f-/p" |\
  sed -e "s/^$f-/map g/" -e 's/:/ $cd/' >> lf.automated.$long_hostname
done
}

for f in ${locals[@]}
do
  cp ../lf/lfrc.base lf.automated.$f
  printf "\n# files {{{2\n\n" >> lf.automated.$f
  cat files | sort | clean | sed -e 's/^/map o/' -e 's/:/ $vim/' >> lf.automated.$f 
  printf "\n# movement {{{2\n\n" >> lf.automated.$f
  cat folders | sort | clean | sed 's/^/map g/;s/:/ $cd/' >> lf.automated.$f
done 

locals="MU00151959X macbook"
slurm="mgs mas mon stm"
pbs="rjn"
make_configs 'local' ${locals[@]}
make_configs 'slurm' ${slurm[@]}
make_supercomp_configs 'pbs' ${pbs[@]}

# everywhere

cat files | sort | clean | sed -e 's/^/alias o/' -e "s/:/='vim/" -e "s/$/'/" > bash_aliases
cat folders | sort | clean | sed -e 's/^/alias g/' -e "s/:/='cd/" -e "s/$/'/" >> bash_aliases
