#!/usr/bin/env bash
# Convert images to grayscale versions.

if [[ "$(pwd)" == *booklet ]]
then
    cd img/student/

    for file in ./*; do
	convert -colorspace gray $file $file
    done
else
    echo "Must run generator within the \"booklet\" directory."
fi
