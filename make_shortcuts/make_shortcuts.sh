#!/usr/bin/env sh

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

make_supercomp_configs(){
scheduler=$1 # slurm or pbs
supercomps=${@:2} 
for f in $supercomps
do
  cp ../lf/lfrc.base.$scheduler lf.automated.$f
  echo "\n# movement {{{2\n" >> lf.automated.$f
  cat folders |\
  sort |\ 
  delete_blanks |\
  rm_comments |\
  sed -n "/$f-/p" |\
  sed -e "s/^$f-/map g/" -e 's/:/ $cd/' >> lf.automated.$f
done
}

cat files | sort | clean | sed -e 's/^/map o/' -e 's/:/ $vim/' > lf_shortcuts
cat folders | sort | clean | sed 's/^/map g/;s/:/ $cd/' >> lf_shortcuts
cat files | sort | clean | sed -e 's/^/alias o/' -e "s/:/='vim/" -e "s/$/'/" > bash_aliases
cat folders | sort | clean | sed -e 's/^/alias g/' -e "s/:/='cd/" -e "s/$/'/" >> bash_aliases

slurm="mgs mas mon stm"
pbs="rjn"
make_supercomp_configs 'slurm' ${slurm[@]}
make_supercomp_configs 'pbs' ${pbs[@]}
