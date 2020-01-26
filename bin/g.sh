#!/bin/sh
d=$(cd $(dirname $0) && pwd)
cd $d/../

git init
git remote add origin git@github.com:tkosht/py3.git
git fetch
git pull origin master

# edit .gitignore
# git add .
# git commit -m 'init: initial commit'
# git push
