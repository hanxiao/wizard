#!/usr/bin/env bash

setup_git() {
  git config --global user.email "artex.xh@gmail.com"
  git config --global user.name "Han Xiao"
}

commit_generated_wizard() {
  git checkout master
  git add .version ./gnes-wizard.sh
  git commit --message "Travis auto build: $TRAVIS_BUILD_NUMBER"
}

upload_files() {
  git remote add origin https://hanxiao:${GH_TOKEN}@github.com/gnes-ai/wizard > /dev/null 2>&1
  git push --quiet --set-upstream origin master
}

setup_git
commit_generated_wizard
upload_files