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

add_pbs_to_lfrc(){
  printf "# PBS {{{2\n\n" >> $1
  echo 'map sb $qsub "$f"' >> $1
  echo 'map sj $submit_jobs' >> $1
  echo 'map squ !qstat -u tm3124' >> $1
  echo 'map sqo !nqstat' >> $1
  echo 'map sql !nqstat' >> $1
}

add_slurm_to_lfrc(){
  printf "# SLURM {{{2\n\n" >> $1
  echo 'map sb $sbatch "$f"' >> $1
  echo 'map sj $submit_jobs' >> $1
  echo 'map squ !squeue -u $USER -o "%.18i %.9P %.30j %.8u %.2t %.10M %.6D %R"' >> $1
  echo 'map sql !squeue -u $USER -o "%.10i %.50Z %.10P %.15j %.8u %8Q %.8T %.10M %.4C %.12l %.12L %.6D %.16S %R"' >> $1
  echo 'map sqo !squeue -u $USER -o "%10i %30j %130Z"' >> $1
}

make_configs(){
    f="$1"
    long_hostname=${conversion[$f]}
    lfrc="$DOTS/lf/lfrc.$long_hostname"
    alias="$DOTS/aliases/aliases.$long_hostname"

    # mac files/folders labelled as mac-au or mac-gbmo
    [[ $f =~ (uni|home) ]] && f='mac' 
    cp $DOTS/lf/lfrc.base $lfrc
    [[ $f =~ (gadi|rjn) ]] && add_pbs_to_lfrc $lfrc
    [[ $f =~ (mgs|mas|mon|stm) ]] && add_slurm_to_lfrc $lfrc

    printf "\n# Files {{{2\n\n" >> $lfrc
    cat $SHORTCUTS/files | sort | clean | sed -e 's/^/map o/' -e 's/:/ $vim/' >> $lfrc
    printf "\n# Movement {{{2\n\n" >> $lfrc
    cat $SHORTCUTS/folders | sort | delete_blanks | rm_comments | sed -n "/$f-/p" |\
    sed -e "s/^$f-/map g/" -e 's/:/ cd/' >> $lfrc
    cp $DOTS/aliases/aliases.base $alias
    printf "\n# files {{{1\n\n" >> $alias
    cat $SHORTCUTS/files | sort | clean | sed -e 's/^/alias o/' -e "s/:/='vim/" -e "s/$/'/" >> $alias
    printf "\n# movement {{{1\n\n" >> $alias
    cat $SHORTCUTS/folders | sort | delete_blanks | rm_comments | sed -n "/$f-/p" |\
    sed -e "s/^$f-/alias g/" -e "s/:/='cd/" -e "s/$/'/" >> $alias
    
    # zshrc for mac
    while ! $zshdone
    do
      if [[ $f == "mac" ]] 
      then
        sed '/#  SHORTCUTS  #/q' $DOTS/zshrc > tmpzsh
        echo '###############' >> tmpzsh
        printf "\n# files\n\n" >> tmpzsh
        cat $SHORTCUTS/files |
          sort | clean |
          sed -e 's/^/alias o/' -e "s/:/='vim/" -e "s/$/'/" >> tmpzsh
        printf "\n# movement\n\n" >> tmpzsh
        cat $SHORTCUTS/folders |
          sort | delete_blanks | rm_comments |
          sed -n "/$f-/p" |
          sed -e "s/^$f-/alias g/" -e "s/:/='cd/" -e "s/$/'/" >> tmpzsh
        zshdone=true
        mv tmpzsh $DOTS/zshrc
      fi
    done
}


main(){
  confs="uni home mgs mas mon stm rjn gadi"
  zshdone=false # mac
  for conf in ${confs[@]}
  do
    make_configs $conf
  done
}

main
