#!/usr/bin/env bash
# Starts the parser.
# TODO: Maintain relative (?) path.

if [[ "$(pwd)" == *booklet ]]
then
    cd .parser
    ./clean.sh
    ruby parse.rb
else
    echo "Must run generator within the \"booklet\" directory."
fi
