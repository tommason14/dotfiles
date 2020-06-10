#!/usr/bin/env bash

CYAN='\[\e[0;36m\]'
NO_COLOUR='\[\e[0m\]'
DATE=$(date '+%d/%m')

declare -A host
host["gadi"]="Gadi"
host["mon"]="Mon"
host["m3"]="M3"
host["stampede"]="Stm"
host["MBP"]="Mac"
host["MU00151959X"]="Mac"

for name in "${!host[@]}"
do
  if [[ $HOSTNAME =~ "$name" ]]; then
    export PS1="${CYAN} ${host[$name]} \W \$ ${NO_COLOUR}"
  fi
done
