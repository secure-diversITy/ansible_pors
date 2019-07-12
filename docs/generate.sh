#!/bin/bash
export PROJECT_NUMBER="$(git rev-parse HEAD ; git diff-index --quiet HEAD || echo '(with uncommitted changes)')"
export PROJECT_NUMBER="Generated: $(date +%Y-%m-%d)"
cd ./docs
exec doxygen
