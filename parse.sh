#!/usr/bin/env bash
# Starts the parser.
# TODO: Maintain relative (?) path.

if [[ "$(pwd)" == *booklet ]]
then
    cd .parser
    ./clean.sh
    ruby parse.rb $1
    ./convert_imgs.sh
else
    echo "Must run generator within the \"booklet\" directory."
fi
