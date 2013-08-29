#!/usr/bin/env bash
# Put this in a for loop and repeat for each directory.
# See http://www.linuxquestions.org/questions/programming-9/bash-delete-all-but-certain-files-696857/#post3406903

if [[ "$(pwd)" == *.parser ]]; then
    shopt -s extglob

    for dir in img txt markdown resume ../posts; do
	if [ ! -d "$dir" ]; then
	    mkdir $dir
	fi	
    done

    rm img/* #.jpg, .png
    rm txt/* #.txt
    rm markdown/* #.md
    rm resume/* #.doc, .docx, .pdf
    rm ../_posts/* #.md (different formats?)

else
    echo "Cleaner must be run within the \".parser\" directory."
fi
