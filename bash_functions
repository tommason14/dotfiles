#!/usr/bin/env bash

if [[ $USER =~ (tommason|tmas0023) ]]; then

  xaringan_to_pdf() {
    decktape remark --chrome-arg=--allow-file-access-from-files $1 ${1%.html}.pdf 
  }

  reveal_to_pdf() {
    decktape reveal http://localhost:1948/$1 $2 -s "1200x800"
  }

  latex_compile() { latexmk -pvc -pdfxe $1 & }

  make_pdf() {
    pandoc $1 --pdf-engine=xelatex --filter=pandoc-citeproc -o ${1%.md}.pdf 
    open ${1%.md}.pdf
  }

  make_tex() {
    pandoc $1 --biblatex --pdf-engine=xelatex --filter=pandoc-citeproc -o ${1%.md}.tex
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
      if [[ -f $TEX.$arg ]]; then
        echo "Removing $TEX.$arg"
        rm $TEX.$arg
      fi
    done
  }

  check_references(){
    grep -i "@article{$1" "$repos/thesis/refs.bib" |
    sed 's/\@article{//' |
    sed 's/\,//' |
    sort
  }

  pymol(){ 
   /Applications/PyMOL.app/Contents/MacOS/PyMOL $@ -d "@~/.pymolrc"
  }

  wl(){
    [[ "$#" -eq 0 ]] && echo "Syntax: wl wallpaper_file options" && return 1
    $HOME/Documents/repos/wallpapers/make_wallpaper.sh "$@"
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
    convert ${@:1:$#-1} -gravity center -append ${@:-1} 
    # ${@: -1} only works with arguments
  }

fi

###################
#  Colourschemes  #
###################
source ~/dotfiles/colours.functions

# default alias sc already on monarch
scr(){
 $EDITOR $(find ~/.local/scripts -type f | grep -v '.git\|pycache' | fzf --preview='less {}')
}

escr(){
  $(find ~/.local/scripts -type f | grep -v '.git\|pycache' | fzf --preview='less {}')
}

escr(){
  $(find ~/.local/scripts -type f | grep -v '.git\|pycache' | fzf --preview='less {}')
}

nohup_bg() {
  nohup $1 < /dev/null > nohup_bg.log &
}

goto(){
  [ $# -eq 0 ] &&
  echo "Navigates to the working directory of a SLURM/PBS job." &&
  echo "Syntax: goto JOBID" && return 1
  [ $USER == "tm3124" ] && 
  cd $(qstat -f $1 | sed -n '/PBS_O_WORKDIR/,/PBS_O/p' | sed 's/,PBS.*//;s/PBS_O_WORKDIR=//' | tr -d '\n' | sed 's/\s//g' | awk -F',' '{print $1}') ||
  cd $(scontrol show jobid $1 | grep WorkDir | awk -F'=' '{print $2}')
}

goto_finished(){
  [[ $# -ne 1 || $1 == '-h' ]] &&
    echo "Navigates to the working directory of a SLURM/PBS job that has already finished." &&
    echo "Syntax: goto_pbs_finished JOBID" &&
    return 1

  [[ $USER =~ tmason ]] &&
    cd $(sacct -j $1 --format='WorkDir%200' | awk 'NR==3 {print $1}') ||
    cd $(qstat -fxw $1 | grep Output_Path | cut -d '=' -f2 | cut -d':' -f2 | awk -F'/' '{OFS="/"; $NF=""; print $0}')
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

pull_repos() {
  pushd ~/dotfiles
  echo "Updating dotfiles..."
  git pull && source ~/.bashrc 
  cd ~/autochem
  echo "Updating autochem..." 
  git pull
  echo "Updating qcp..."
  pull_qcp
  cd ~/.local/scripts
  echo "Updating scripts..."
  git pull 
  popd
}

push_repos() {
  pushd ~/dotfiles
  echo "Pushing dotfiles to github..."
  git add . && git commit && git push
  cd ~/autochem
  echo "Pushing autochem to github..." 
  git add . && git commit && git push
  echo "Pushing qcp to github..."
  push_qcp
  cd ~/.local/scripts
  echo "Pushing scripts to github..."
  git add . && git commit && git push
  popd
}

force_push() {
  git add .
  git commit --amend --no-edit
  git push --force
}

make_gif() {
  convert -loop 0 -delay 20 image* run.gif
}

# make dirs from xyz files- template in top directory (works for gaussian
# for gamess; not necessary as new dir already created- pass in template file
# i.e. make_subdirs gauss.template
# then run qcp from that dir
function make_subdirs {
  top_dir=$(pwd)
  for f in $(find . -path "*xyz"); do 
    dir_name=$(dirname "$f")
    base_name=$(basename "$f")
    file_name=$(echo "$base_name" | cut -d . -f 1)
    cd "$dir_name"
    mkdir "$file_name"
    cd "$file_name"
    cp "$top_dir/$f" .
    cd "$top_dir"
  done
}

function gamesstoxyz {
  base_name=$(echo $1 | cut -d . -f 1)
  num_atoms=$(cat $1 | wc -l | tr -s [:blank:])
  cat $1 | awk 'BEGIN {OFS="\t"}; {print $1, $3, $4, $5}' | column -t > $base_name.xyz
  printf "$num_atoms\n\n" | cat - $base_name.xyz > temp
  mv temp $base_name.xyz 
}

vmd_unwrap() 
{ 
    echo "source ~/.local/scripts/chem/vmd_unwrap.tcl" >> unwrap_vmd.tmp
    vmd $1 $2 -e unwrap_vmd.tmp
    rm unwrap_vmd.tmp
}

copy() {
  command -v xclip >/dev/null &&
  cat ${1:-/dev/stdin} | xclip -selection clipboard ||
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

plot_individual_ir() {
  Rscript -e "read_csv('$1') %>%
    ir_with_lorentzians() %>%
    ggplot() +
    aes(Wave, Int) +
    geom_line()" &> /dev/null
  open Rplots.pdf
  sleep 3 
  rm Rplots.pdf
}

plot_ir_from_csv() {
  half_width=${2:-20}
  Rscript -e "read_csv('$1') %>%
    group_by(File) %>%
    do(ir_with_lorentzians(., $half_width)) %>%
    plot_ir_spectra() +
    facet_wrap(File~.)" &> /dev/null
  open Rplots.pdf
  sleep 3 
  rm Rplots.pdf
}

plot_uv() {
  [[ $1 =~ "-h" || $# -eq 0 ]] && echo "Syntax: plot_uv csvfile [sigma, default=0.05] [step,default=0.01]" && return 1
  sigma=${2:-0.05}
  step=${3:-0.01}
  Rscript -e "read_csv('$1') %>% 
    group_by(Config) %>%
    do(add_gaussians(., $sigma, $step)) %>%
    plot_gaussians() +
    facet_wrap(.~Config, scales='free_y')" &> /dev/null
  open Rplots.pdf
  sleep 3 
  rm Rplots.pdf
}

plot_uv_vertical() {
  [[ $1 =~ "-h" || $# -eq 0 ]] && 
    echo "Syntax: plot_uv csvfile [sigma, default=0.05] [step,default=0.01]" &&
    return 1
  sigma=${2:-0.05}
  step=${3:-0.01}
  Rscript -e "read_csv('$1') %>% 
    group_by(Config) %>% 
    do(add_gaussians(., $sigma, $step)) %>%
    plot_gaussians(curve = '#2a9d8f', lines = '#fb8b24') + 
    theme_tom(font='Fira Code Light') +
    facet_wrap(.~Config, ncol=1, scales='free_y') +
    ggsave('Rplot.png', dpi=300)" &> /dev/null
  open Rplot.png
  sleep 3 
  rm Rplot.png
}
