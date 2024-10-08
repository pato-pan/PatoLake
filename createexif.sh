#!/bin/bash
echo "where there is a will, there is a bread. Always remember to share"
# Makes all images in the current folder have a date created on their metadata, which will equal the date modified. If the file already has a date created, it won't change anything.
# WARNING: This won't make a backup and you can't revert the changes! And it may also have an effect in not just image files.
# This should work on a large folder as well.
# This is not meant to run as a bash script. Since it's just two lines, it's preferred to simply copy the commands and paste in your terminal.

exiftool -P -r -m -overwrite_original "-alldates<filemodifydate" -if 'not ($datetimeoriginal or $createdate or $datetime or $modifydate)' /YOURFOLDERWBAIUSSFSBF &> exiftool.log

# tail -f ./exiftool.log show log in real time
# -P preverse file dates
# -v verbose, adds too many logs though and it feels mostly useless. Better to use only when you want to troubleshoot an issue or it's a few files
# -r recursive for folders. Will be ignored with files
# --overwrite_original prevents exiftool from making a backup of the original. These backups are made in the same location where the file is located, so on a large folder this is a mess. If it's only a single file, removing this is great
# get logs to file
# It's likely you want a log to look into all the files that gave an error. exiftool does this annoying thing where it cares about the extension of the file.
# however, don't put the all the blame on exiftool. Websites like to assign the wrong extensions to their filenames for unknown reasons I will likely not agree with -_-. So use the below script below and create a text file called fixext.txt with all the directories. One group at at time

# This should help renaming the files
# Replace jpg with the orig ext, replace png with the ext it should have. Most images are jpgs that are meant to be a png or another format.
for file in $(cat ./fixext.txt); do mv -- "$file" "${file%.jpg}.png"; done
#original
# Rename all *.txt to *.text
#for file in *.txt; do
#    mv -- "$file" "${file%.txt}.text"
#done

