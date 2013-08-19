#!/usr/bin/env bash
# Convert images to grayscale versions.

if [[ "$(pwd)" == *parser ]]
then
    cd ../img/student/

    for file in ./*; do
	if [[ $file == *.jpg || $file == *.jpeg || $file == *.png ]]; then
	    echo $file
	    convert -colorspace gray $file $file
	fi
    done
else
    echo "Must run grayscale converter within the \"booklet\" directory."
fi
