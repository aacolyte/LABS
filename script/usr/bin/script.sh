#!/bin/bash
echo "Counting the number of files in the etc directory..."
count=0
for f in /etc/*; do
	if [ -f "$f" ]; then
		count=$((count+1))
	fi
done
echo "Number of files in the etc directory: $count"
