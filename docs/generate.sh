#!/bin/bash
export PROJECT_NUMBER="$(git rev-parse HEAD ; git diff-index --quiet HEAD || echo '(with uncommitted changes)')"
export PROJECT_NUMBER="Generated: $(date +%y-%m-%d\ %H:%M:%S)"
cd cd $(dirname $0)
exec doxygen
