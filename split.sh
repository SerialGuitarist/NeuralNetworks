#!/bin/bash

if [ -z "$1" ]
then
    echo "No argument supplied"
    exit
fi

FILES=$1*

index=0

for f in $FILES
do
    ## basic echoing
    echo $index $f

    ## making a temporary folder to work in
    ## basically using the folder as an array
    mkdir "$1/tmp"

    ##using ffmpeg to split the audio into 5 second clips
    ffmpeg -i "$f" -f segment -segment_time 5 -c copy "$1/tmp/$index-%03d.mp3"

    ## removing the first 5 and last 5 5-second slices
    rm $(ls -d "$1"/tmp/* | head -n 5)
    rm $(ls -d "$1"/tmp/* | tail -n 5)

    ## moving all the remaining slices back to the main folder
    mv "$1"/tmp/* "$1/"

    ## deleting the temporary folder
    rmdir "$1/tmp"

    ## removing the original file
    rm "$f"

    ## incrementing the thing
    index=`expr $index + 1`
done

