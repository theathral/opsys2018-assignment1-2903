#!/bin/bash

# Make directories for zip files and repositories
mkdir -p git
mkdir -p assignments

# Unzip directory
tar xf $1 -C git

# Find all .txt files and save the repositories from its one
cd git
find $(pwd) -name '*.txt' > ../repo
cd ..



# Get in the directory with assignments and do everything directly there (Get back when finishes)
cd assignments

# Read one by one the .txt files
while read -r line; do

	website=$(grep -i -m 1 -E "^https*" $line)
	echo $website
	[ -z $website ]  && continue;

	check=0
	git clone --quiet $website  &> /dev/null && check=1

	# Check if cloning was succesful and show suitable message
	[ $check -eq 1 ] && echo "$website: Cloning OK"
	[ $check -eq 0 ] && echo "$website: Cloning FAILED" >> /dev/stderr && continue; #!!!!!!!!!!!!!!!!!stderr

done < ../repo

# Delete the leftover file
rm ../repo



# Search if the file contains the right structure
for repository in *; do

	# Get in the directory and search directly there (Get back when finishes)
	cd $repository

	# Print details of repo
	directories=$( find . -type d | wc -l )
	directories=$(( directories - 1 )) # Delete the current directory
	txtFiles=$( find . -type f -name '*.txt' | wc -l )
	otherFiles=$( find . | wc -l )
	otherFiles=$(( otherFiles - directories - 1 - txtFiles )) # -1: Deletes the current directory

	echo "$repository:"
	echo "Number of directories: $directories"
	echo "Number of txt files: $txtFiles"
	echo "Number of other files: $otherFiles"

	# Check if structure is ok
	[ -e dataA.txt ] && [ -e more/dataB.txt ] && [ -e more/dataC.txt ] \
		&& echo "Directory structure is OK."
	( [ -e dataA.txt ] && [ -e more/dataB.txt ] && [ -e more/dataC.txt ] ) \
		|| echo "Directory structure is NOT OK."  >> /dev/stderr

	cd ..

done;

cd ..
