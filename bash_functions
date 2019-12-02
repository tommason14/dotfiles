#!/usr/bin/env sh

if [[ $USER =~ (tommason|tmas0023) ]]; then
  use() {
    program=$(ls /Applications/ | grep -i "$1" | head -n 1)
    open -a /Applications/"$program" $2
  }

  pres_to_pdf() {
    decktape reveal http://localhost:1948/$1 $2 -s "1200x800"
  }

  latex_compile() { latexmk -pvc -pdfxe $1 & }

  make_pdf() {
  pandoc $1 --pdf-engine=xelatex --filter=pandoc-citeproc -o ${1%.md}.pdf 
  open ${1%.md}.pdf
  }

  make_tex() {
  pandoc $1 --biblatex --pdf-engine=xelatex --filter=pandoc-citeproc -o
  ${1%.md}.tex
  }

  tex() {
    xelatex $1
    bibtex ${1%.tex}
    xelatex $1
    xelatex $1
    rm *.bbl *.log *.blg *.out *.lof *.lot *.toc *.aux
    open ${1%.tex}.pdf
  }

  clean_tex() {
    TEX=$(ls | grep tex$)
    TEX=${TEX%.*}
    args="bbl blg log synctex.gz fls fdb_latexmk out"
    for arg in $args
    do
      if [ -f $TEX.$arg ]; then
        echo "Removing $TEX.$arg"
        rm $TEX.$arg
      fi
    done
  }

  check_references(){
    grep -i @article{$1 $repos/thesis/refs.bib |\
    sed 's/\@article{//' |\
    sed 's/\,//' |\
    sort
  }

  wl(){
    wal -i "$1"
  }

  mr(){
    Rscript -e "require(rmarkdown); render(\"$1\")"
  }

  transparent(){
    fuzz_amount=${2-20}
    output="${1%.*}_transparent.${1##*.}"
    convert $1 -transparent white -fuzz $fuzz_amount% $output
  }

  vertical(){
    convert ${@:1:$#-1} -gravity center -append ${@: -1} 
    # ${@: -1} only works with arguments
  }

fi

nohup_bg() {
  nohup $1 < /dev/null > nohup_bg.log &
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

cdl() {
  cd $1
  ls
}

gitserve() {
  cd ~/Documents/web-design/sites/harp-blog
  harp compile
  cp www #to somewhere
  rm -r www
  cd #somewhere
  gitall
}

bulk_rename() {
  for f in *.$1
  do 
    mv $f $(basename $f .$1).$2
  done
}

zipall(){
  zip $1 -r * -x "*.DS_Store"
}


change_to_chem_assistant() {
  if [[ $PWD == *"565"* || $PWD == *"tmason"* || $PWD == *"tmason1"* || $HOSTNAME == *"stampede"* ]]; then
    cd ~/monash_automation
  elif [[ $PWD == *"tmas0023"*  || $PWD == *"tommason"* || $PWD == *"/Volumes/GoogleDrive"* ]]; then # Uni
    cd ~/Documents/monash_automation
  fi
}

pull_qcp() {
  if  [[ $PWD == *"tmas0023"* || $PWD == *"tommason"* || $PWD == *"/Volumes/GoogleDrive"* ]]; then
    cd "$filestream"/scripts/qcp
    git pull
  elif [[ $HOSTNAME == *"stampede"* ]]; then
    cd /work/06233/tmason/stampede2/qcp
    git pull
  fi
}

push_qcp() {
  if  [[ $PWD == *"tmas0023"* || $PWD == *"tommason"* || $PWD == *"/Volumes/GoogleDrive"* ]]; then
    cd "$filestream"/scripts/qcp
    git add . && git commit && git push
  elif [[ $HOSTNAME == *"stampede"* ]]; then
    cd /work/06233/tmason/stampede2/qcp
    git add . && git commit && git push
  fi
}

change_to_chem_scripts() {
  if  [[ $PWD == *"tmas0023"* || $PWD == *"tommason"* || $PWD == *"/Volumes/GoogleDrive"* ]]; then
    cd "$filestream"/chem_scripts
  elif [[ $PWD == *"565"* || $PWD == *"tmason"* || $PWD == *"tmason1"* || $HOSTNAME == *"stampede"* ]]; then
    cd ~/chem_scripts
  fi
}

pull_repos() {
  pushd ~/dotfiles
  echo "Updating dotfiles..."
  git pull && source ~/.bashrc 
  change_to_chem_assistant
  echo "Updating monash_automation..." 
  git pull
  echo "Updating qcp..."
  pull_qcp
  change_to_chem_scripts
  echo "Updating chem scripts..."
  git pull 
  popd
}

push_repos() {
  pushd ~/dotfiles
  echo "Pushing dotfiles to master..."
  git add . && git commit && git push
  change_to_chem_assistant
  echo "Pushing monash_automation to master..." 
  git add . && git commit && git push
  echo "Pushing qcp to master..."
  push_qcp
  change_to_chem_scripts
  echo "Pushing chem scripts to master..."
  git add . && git commit && git push
  popd
}

force_push() {
  git add .
  git commit --amend --no-edit
  git push --force
}

make_gif() {
  args="$@"
  convert -loop 0 -delay 20 image* run.gif
}


submit_jobs() {
  if [[ $HOSTNAME =~ (magnus|monarch|m3|stampede) ]]
  then
    submit=sbatch
  elif [[ $HOSTNAME == *"raijin"* ]]
  then
    submit=qsub
  fi
  cwd=$(pwd)
  for f in $(find . -path "*job") 
  do 
    cd $(dirname $f)
    $submit $(basename $f)    
    cd $cwd
  done
}

# make dirs from xyz files- template in top directory (works for gaussian
# for gamess; not necessary as new dir already created- pass in template file
# i.e. make_subdirs gauss.template
# then run qcp from that dir
function make_subdirs {
  top_dir=$(pwd); for f in $(find . -path "*xyz"); do dir_name=$(dirname $f);
  base_name=$(basename $f); file_name=$(echo $base_name | cut -d . -f 1); cd
  $dir_name; mkdir $file_name; cd $file_name; cp $top_dir/$1 . ;
  cp $top_dir/$f .; cd $top_dir; done
}

function gamesstoxyz {
  base_name=$(echo $1 | cut -d . -f 1)
  num_atoms=$(cat $1 | wc -l | tr -s [:blank:])
  cat $1 | awk 'BEGIN {OFS="\t"}; {print $1, $3, $4, $5}' | column -t > $base_name.xyz
  printf "$num_atoms\n\n" | cat - $base_name.xyz > temp
  mv temp $base_name.xyz 
}

copy() {
  cat $1 | pbcopy
}

lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}

plot_ir() {
Rscript -e "read_tsv('$1') %>% ir_with_lorentzians() %>% ggplot() + aes(Wave, Int) + geom_line()" &> /dev/null
open Rplots.pdf
sleep 3 
rm Rplots.pdf
}
