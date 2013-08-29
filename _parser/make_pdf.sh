#!/usr/bin/env bash
# Creates a single pdf from the web pages that can be printed out in booklet
# form.
# If using Linux, refer to
# http://wingdspur.com/2012/12/installing-wkhtmltopdf-on-ubuntu/

files=""

while read line
do
    line=$line | tr '\n' ' '
    files="${files}http://0.0.0.0:4000/${line} "

done < "pdf_page_names.txt"

files="${files}http://0.0.0.0:4000/blank.html"

wkhtmltopdf --ignore-load-errors --disable-pdf-compression --disable-smart-shrinking -B 0 -T 0 -R 0 -L 0 $files booklet.pdf
# wkhtmltopdf -B 0 -T 0 -R 0 -L 0 $files booklet.pdf
# Other useful options, like for bolding and styling?
