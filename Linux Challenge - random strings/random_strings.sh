#!/bin/bash
##Written by Robert Bereny - 2020.
##For Mooqita online linux challenge. Version 3.
##This is the third iteration of the script
##All the work, except comparing the output files is done in one line now.

#output files
OUTPUT="output.txt"
FILTERED_OUTPUT="filtered_output.txt"

#output file size limit is currently set to 1MB
let LIMIT=1024*1024 #ASSUMPTION THAT MBs is 1024*1024 BYTES or 1,048,576 BYTES

#max length of a line in the output file, not including newline char:
let LEN=15

#this line does all the work creating the file and limiting the line and file size; then sorting it and creating a second filtered file
cat /dev/urandom | tr -cd 'A-Za-z0-9' | fold -w $LEN | head -c $LIMIT | sort | tee $OUTPUT | grep -v -E "^a|^A" > $FILTERED_OUTPUT

echo Output file $OUTPUT created and sorted, size is: $(cat $OUTPUT | wc -c) bytes
let REMOVED=$(cat $OUTPUT | wc -l)-$(cat $FILTERED_OUTPUT | wc -l)
echo Filtered output file $FILTERED_OUTPUT created, with $REMOVED lines removed.
