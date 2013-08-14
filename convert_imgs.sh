#!/usr/bin/env bash
# Convert images to grayscale versions.

cd img/student/

for file in ./*; do
    convert -colorspace gray $file $file
done
