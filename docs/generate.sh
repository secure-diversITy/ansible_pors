#!/bin/bash
###############################################################################################################
# execute this from the ROOT of the repo!
###########################################

export PROJECT_NUMBER="$(git rev-parse HEAD ; git diff-index --quiet HEAD || echo '(with uncommitted changes)')"
export PROJECT_NUMBER="Generated: $(date +%Y-%m-%d)"
cd ./docs
(exec doxygen)
cd ../github.io/pors/
git checkout develop
git status
echo -e "\n\tcd github.io/pors/\n\tgit add .\n\tgit commit -a -m 'update documentation'\n\tgit push\n"
git checkout master
git merge develop
git push
