#!/usr/bin/env sh

git pull 
git add .
git commit
git push

# update public gist
gist -u 6dfe3e8fc4c49a3bc913022effe37288 jupyter/ipythonrc
