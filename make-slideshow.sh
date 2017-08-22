#!/bin/bash

usage="
Make a reveal.js slideshow, e.g. of the contents of directory
    $0 (files to put on slides) > (output html document)
for instance,
    make-slideshow.sh *png > index.html

"

PANDOC_OPTS="-t slidy --standalone"

(
    for fname in "$@"
    do
        echo "--------------------"
        echo ""
        echo "![${fname}](${fname}){width=100% height=100%}"
        echo ""
    done
    echo "--------------------"
) | pandoc $PANDOC_OPTS 

