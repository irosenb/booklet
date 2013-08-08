#!/usr/bin/env bash
# Starts the parser.

cd .parser
./clean.sh
ruby parse.rb
