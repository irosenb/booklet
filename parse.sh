#!/usr/bin/env bash
# Starts the parser.
# TODO: Maintain relative (?) path.

cd .parser
./clean.sh
ruby parse.rb

# .parser/clean.sh
# ruby .parser/parse.rb
