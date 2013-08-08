#!/usr/bin/env bash
# Put this in a for loop and repeat for each directory
# See http://www.linuxquestions.org/questions/programming-9/bash-delete-all-but-certain-files-696857/#post3406903

shopt -s extglob

cd img
cp parse* ../bak/parse_img.rb
rm !(parse*)
#pwd
cd ../txt
cp parse* ../bak/parse_txt.rb
rm !(parse*)
#pwd
cd ../markdown
cp parse* ../bak/parse_md.rb
rm !(parse*)
#pwd
cd ../resume
cp parse* ../bak/parse_resume.rb
rm !(parse*)
#pwd
