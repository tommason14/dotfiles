tex() {

pdflatex $1
bibtex ${1%.tex}
pdflatex $1
pdflatex $1
open ${1%.tex}.pdf
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

update_repos() {
  cd ~/dotfiles
  echo "Updating dotfiles..."
  git pull && source ~/.bashrc #if error, no reload of bashrc
  cd ~/Documents/monash_automation
  echo "Updating monash_automation..." 
  git pull
}
