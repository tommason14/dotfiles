#!/usr/bin/env sh

make_pdf() {
pandoc $1 -H preamble.tex --pdf-engine=xelatex --filter=pandoc-citeproc -o ${1%.md}.pdf 
open ${1%.md}.pdf
}

tex() {
  pdflatex $1
  bibtex ${1%.tex}
  pdflatex $1
  pdflatex $1
  open ${1%.tex}.pdf
}

clean_tex() {
  args="bbl blg log synctex.gz fls fdb_latexmk out"
  for arg in $args
  do
    if [ -f $1.$arg ]; then
      rm $1.$arg
    fi
  done
}


gitall() {

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
for f in *.$1; do mv $f `basename $f .$1`.$2; done;
}

zipall(){
zip $1 -r * -x "*.DS_Store"
}


if [[ $PWD == *"565"* ]]; then

  sub() {
     pwd >> ~/submissions.txt
     qsub $1 2>&1 | tee -a ~/submissions.txt     
  }

  addtosub() {
    echo "$@" >> ~/submissions.txt
  }

fi

if [[ $PWD == *"tmason"* ]]; then

  sub() {
     pwd >> ~/submissions.txt
     sbatch $1 2>&1 | tee -a ~/submissions.txt     
  }

  addtosub() {
    echo "$@" >> ~/submissions.txt
  }

fi

pull_repos() {
  pushd ~/dotfiles
  echo "Updating dotfiles..."
  git pull && source ~/.bashrc #if error, no reload of bashrc
  if [[ $PWD == *"565"* || $PWD == *"tmason"* || $PWD == *"tmason1"* ]]; then
    cd ~/monash_automation
  elif [[ $PWD == *"tommason"* ]]; then # MacBook
    cd ~/Documents/Monash/monash_automation
  elif [[ $PWD == *"tmas0023"* ]]; then # Uni
    cd ~/Documents/monash_automation
  fi
  echo "Updating monash_automation..." 
  git pull
  popd
}

push_repos() {
  pushd ~/dotfiles
  echo "Pushing dotfiles to master..."
  git add . && git commit && git push
  if [[ $PWD == *"565"* || $PWD == *"tmason"* || $PWD == *"tmason1"* ]]; then
    cd ~/monash_automation
  elif [[ $PWD == *"tommason"* ]]; then # MacBook
    cd ~/Documents/Monash/monash_automation
  elif [[ $PWD == *"tmas0023"* ]]; then # Uni
    cd ~/Documents/monash_automation
  fi
  echo "Pushing monash_automation to master..." 
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

