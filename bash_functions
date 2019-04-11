#!/usr/bin/env sh

pres_to_pdf() {
  decktape reveal http://localhost:1948/$1 $2 -s "1200x800"
}

nohup_bg() {
  nohup $1 < /dev/null > nohup_bg.log 2>&1 &
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

# scp from remote
function scpstam {
  scp tmason@stampede2.tacc.utexas.edu:$1 $2
}

# make dirs from xyz files- template in top directory (works for gaussian
# for gamess; not necessary as new dir already created- pass in template file
# i.e. make_subdirs template
function make_subdirs {
top_dir=$(pwd); for f in $(find . -path "*xyz"); do dir_name=$(dirname $f);
base_name=$(basename $f); file_name=$(echo $base_name | cut -d . -f 1); cd
$dir_name; mkdir $file_name; cd $file_name; cp $top_dir/$1 . ;
cp $top_dir/$f .; cd $top_dir; done
}

function gamesstoxyz {
base_name=$(echo $1 | cut -d . -f 1)
num=$(cat $1 | wc -l | tr -s [:blank:])
cat $1 | tr -s [:blank:] | cut -d ' ' -f 1,3- | sed 's/ /   /g' | column -t > $base_name.xyz
printf "$num\n\n" | cat - $base_name.xyz > /tmp/out
mv /tmp/out $base_name.xyz # avoids sed -i '' on mac/ sed -i on linux
}

function calc {
args=$(printf "$*" | tr -d [:blank:] | sed 's/\*/\\*/') #rm spaces, replace * with \*, so doesn't
echo $args
# print all files in dir- replace divide sign by /\
python3 -c "print($args)"
}
