#!/usr/bin/env bash
# Put this in a for loop and repeat for each directory
# See http://www.linuxquestions.org/questions/programming-9/bash-delete-all-but-certain-files-696857/#post3406903

shopt -s extglob

pwd
#cd img
#cp parse* ../bak/parse_img.rb
#rm !(img/parse*)
rm img/parse*
pwd
#pwd
#cd ../txt
#cp parse* ../bak/parse_txt.rb
#rm !(txt/parse*)
rm txt/parse*
pwd
#pwd
#cd ../markdown
#cp parse* ../bak/parse_md.rb
#rm !(markdown/parse*)
rm markdown/parse*
#pwd
pwd
#cd ../resume
#cp parse* ../bak/parse_resume.rb
#rm !(resume/parse*)
rm resume/parse*
#pwd


# cd and rm dirs are not maintained
