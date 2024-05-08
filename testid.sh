#!/bin/bash

num_processes=50
num_ids=5000

# Remove any old test files
rm -f testid.*.out

# Run genid concurrently in the background
for i in $(seq 1 $num_processes); do
  for j in $(seq 1 $((num_ids / num_processes))); do
    ./genid.sh >> testid.$i.out 2>/dev/null &
  done
done

# Wait for all background processes to complete  
wait

# Combine all the output files and sort the IDs
cat testid.*.out | sort -n > testid.all.out

# Check for missing or duplicate IDs
prev_id=0
while read id; do
  if [[ $id != $((prev_id + 1)) ]]; then
    echo "Error: Missing or duplicate ID found around $prev_id/$id"
    exit 1
  fi
  prev_id=$id  
done < testid.all.out

echo "Test passed: $num_ids sequential IDs generated with no gaps or duplicates"
