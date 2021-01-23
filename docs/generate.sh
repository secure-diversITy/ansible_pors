#!/bin/bash
export PROJECT_NUMBER="$(git rev-parse HEAD ; git diff-index --quiet HEAD || echo '(with uncommitted changes)')"
export PROJECT_NUMBER="Generated: $(date +%Y-%m-%d)"
cd ./docs
(exec doxygen)
cd ../github.io/pors/
git status
echo -e "\n\tcd github.io/pors/\n\tgit commit -m 'update documentation'\n\tgit push\n"
