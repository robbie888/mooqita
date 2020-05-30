#!/bin/bash
##Written by Robert Bereny - 2020.
##For Mooqita online linux challenge. Version 2.
##This is the second iteration of the script
## No loop needed!

#output files
OUTPUT="output.txt"
FILTERED_OUTPUT="filtered_output.txt"

#output file size limit is currently set to 1MB
let LIMIT=1024*1024 #ASSUMPTION THAT MBs is 1024*1024 BYTES or 1,048,576 BYTES

#max length of a line in the output file, not including newline char:
let LEN=15

#create new file for output, overwritting any existing file of the same name...
echo -n "" > $OUTPUT #output file

#this line does all the work creating the file and limiting the line and file size.
cat /dev/urandom | tr -cd 'A-Za-z0-9' | fold -w $LEN | head -c $LIMIT > $OUTPUT

let FSIZE=$(cat $OUTPUT | wc -c)
echo File $OUTPUT created, file is $FSIZE bytes

#now sort the file using default option to keep the leading numeric strings first
echo Sorting the file...
sort $OUTPUT -o $OUTPUT

#now remove the lines leading with an 'a'
echo Removing lines leading with an \'a\' or \'A\'...
grep -v -E "^a|^A" $OUTPUT > $FILTERED_OUTPUT
let REMOVED=$(cat $OUTPUT | wc -l)-$(cat $FILTERED_OUTPUT | wc -l)
echo $FILTERED_OUTPUT created, $REMOVED lines removed.
