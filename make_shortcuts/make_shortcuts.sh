#!/usr/bin/env sh

rm_comments(){
  sed '/^#/d'
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
  sed '/^$/d' |\
  rm_supercomps
}

# # multiple sed commands linked by either -e or ;
# cat files | sort | clean | sed -e 's/^/map o/' -e 's/:/ $vim/' >> lf_shortcuts
# echo >> lf_shortcuts
# cat folders | sort | sed 's/^/map g/;s/:/ $cd/' >> lf_shortcuts
#
# cat files | sort | sed -e 's/^/alias o/' -e "s/:/='vim/" -e "s/$/'/" >> bash_aliases
# # echo >> bash_aliases
# cat folders | sort | rm_comments | rm_supercomps | sed -e 's/^/alias g/' -e "s/:/='cd/" -e "s/$/'/" >> bash_aliases

supers="mgs rjn mas mon stm"
for f in ${supers[@]}
do
  cat folders | sort | rm_comments | sed '/^$/d' | sed -n "/$f-/p" | sed -e "s/^$f-/map g/" -e 's/:/ $cd/' > $f
done
