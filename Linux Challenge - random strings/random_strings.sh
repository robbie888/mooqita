#!/bin/bash
##Written by Robert Bereny - 2020.
##For Mooqita online linux challenge. 

#output files
OUTPUT="output.txt"
SORTED_OUTPUT="sorted_output.txt"
FILTERED_OUTPUT="filtered_output.txt"
TEMP_FILE="temp.txt" #this file is removed at the end of the script

#output file size limit is currently set to 1MB
let LIMIT=1024*1024 #ASSUMPTION THAT MBs is 1024*1024 BYTES or 1,048,576 BYTES

#multiplier of amount of bytes to read from /dev/urandom per iteration.
#currently set to same value as limit, this seems to be reasonable for speed. But for very large output files this should be changed.
let MULTI=$LIMIT

#max length of a line in the output file, not including newline char:
let LEN=15

#create new files for working, overwritting any existing file of the same name...
echo -n "" > $TEMP_FILE #temp working file
echo -n "" > $OUTPUT #output file

let FSIZE=$(cat $OUTPUT | wc -c) #set FSIZE variable for usage below. 

#while the output file size is less than the limit, continue adding random strings. 
while [[ $FSIZE -lt $LIMIT ]]
do 
    #the following line gets the random data and organises it into alphanumeric chars. Elaborated:
        #head gets the data from /dev/urandom, tr removes all the non alphanumeric chars from the stream, note a lot are removed
        #fold enforces the line length max, and echo puts a new line at the end of the last line of the stream.
        #result is put into $TEMP_FILE which then gets checked for size and is added to the OUTPUT file accordingly.
    head -c $MULTI /dev/urandom | tr -cd 'A-Za-z0-9' | (fold -w $LEN ; echo ) > $TEMP_FILE
    let TMP_FSIZE=$(cat $TEMP_FILE | wc -c)

    #ensure file size LIMIT is not exceeded.
    #Check temp file if its input will exceed the limit then only add a portion of it to the output.
    if [[ $TMP_FSIZE+$FSIZE -lt $LIMIT ]]
    then
        cat $TEMP_FILE >> $OUTPUT
    else #adding a portion of the $TEMP_FILE to the output file
        let DIFF=$LIMIT-$FSIZE-1 #Add only the amount needed to fill the file, the -1 is for the newline char at the end
        (head -c $DIFF $TEMP_FILE ; echo) >> $OUTPUT
    fi
    let FSIZE=$(cat $OUTPUT | wc -c) #update the output file size variable for the next iteration. 
done

echo Your $OUTPUT file is $FSIZE bytes

#now sort the file and put into new file, using default option which keeps the leading numeric strings first
echo Sorting the file into $SORTED_OUTPUT
sort $OUTPUT > $SORTED_OUTPUT

#now remove the lines leading with an 'a'
echo Removing lines leading with an \'a\' or \'A\' and putting results into $FILTERED_OUTPUT
grep -v -E "^a|^A" $SORTED_OUTPUT > $FILTERED_OUTPUT

let REMOVED=$(cat $SORTED_OUTPUT | wc -l)-$(cat $FILTERED_OUTPUT | wc -l)
echo Number of lines removed $REMOVED 

#clean up remove $TEMP_FILE file.
echo Removing temporary file
rm -f $TEMP_FILE



