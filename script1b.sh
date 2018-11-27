#!/bin/bash

# Make dir for all addresses, if there is not any
mkdir -p knownAddresses

# Read one by one the websites from file at the argument of the script
filename=$1
while read -r line; do
(

	# Separate comments froms others
	( [ -z $line ] || [ ${line:0:1} == "#" ] ) && continue;


	# Change / with .
        lineWithDots=$(sed 's|\/|.|g' <<< "$line" )

	# Download website
	wget -q --no-parent --html-extension --output-document $lineWithDots $line &> /dev/null

	# Check if  the file copied succesfully
	[ $? -ne 0 ] && ( echo "$line FAILED" >> /dev/stderr ) && touch knownAddresses/$lineWithDots && rm $lineWithDots && continue;



	# If website structure does't exist, print "website + INIT"
	[ -e knownAddresses/$lineWithDots ] || echo "$line INIT"

	# If website exists, report changes by printing the website
	[ -e knownAddresses/$lineWithDots ] && ( diff knownAddresses/$lineWithDots $lineWithDots &> /dev/null || echo $line )


	# Save changes / Update file
	mv $lineWithDots knownAddresses/$lineWithDots

) & # This ambersand puts the current procedure to the background and continues to the next command
done < $filename

# Wait all procedures to finish
wait

