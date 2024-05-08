#!/bin/bash

genid() {
  # Use a lock file to ensure only one process can generate an ID at a time
  lockfile="genid.lock"

  # Loop until we can acquire the lock
  while ! ln "$lockfile" "$lockfile.lock" 2>/dev/null; do
    sleep 0.1
  done

  # Get the current max ID from the file, default to 0 if file doesn't exist 
  max_id=$(cat genid.dat 2>/dev/null || echo 0)
  
  # Increment the max ID
  next_id=$((max_id + 1))
  
  # Zero-pad the ID to 5 digits
  printf -v padded_id "%05d" $next_id
  
  # Write the new max ID back to the file  
  echo $next_id > genid.dat

  # Release the lock
  rm -f "$lockfile.lock"

  # Output the padded ID
  echo $padded_id
}
