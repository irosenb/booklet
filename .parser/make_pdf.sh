#!/usr/bin/env bash
# Creates a single pdf from the web pages that can be printed out in booklet
# form.
# If using Linux, refer to
# http://wingdspur.com/2012/12/installing-wkhtmltopdf-on-ubuntu/

# Grab them by the folder

# cd ../_site/

# for file in $

# Alternatively, grab them by their localhost addresses

while read line
do
    echo "$line"
    wkhtmltopdf http://0.0.0.0:4000/$line end.pdf # or add em to array?
done < "pdf_page_names.txt"
