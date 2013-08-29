#!/usr/bin/env bash
# Convert images to grayscale versions.

if [[ "$(pwd)" == *parser ]]
then
    cd ../img/student/

    for file in ./*; do

	if [[ $file == *.jpg || $file == *.jpeg || $file == *.png ]]; then
	    convert -colorspace gray $file $file
	fi

	if [[ $file == *.png ]]; then
	    other=(${file//./ })
	    other=".${other}"
	    otherjpg="${other}.jpg"
	    otherpng="${other}.png"

	    convert $otherpng $otherjpg
	fi

    done

    echo "\nFinished converting images.\n"

else
    echo "Must run grayscale converter within the \"booklet\" directory."
fi
