#!/bin/bash

# Loop through all .mov files in the current directory
for file in *.mov; do
  # Generate new file name with .mp4 extension
  newfile="${file%%.mov}.mp4"
  
  # Convert .mov to .mp4 using FFmpeg with a higher quality setting (CRF)
  # Using CRF 21 as a balance between quality and file size
  # Preset can be adjusted for encoding speed ('veryfast', 'faster', 'fast', 'medium', 'slow', 'slower', 'veryslow').
  # A slower preset will provide better compression (quality per file size).
  ffmpeg -i "$file" -vcodec libx264 -crf 21 -preset medium -acodec aac -b:a 128k "$newfile"
  
  # Check if the conversion was successful
  if [ $? -eq 0 ]; then
    echo "Conversion successful: $file -> $newfile"
    # Delete the original .mov file
    rm "$file"
  else
    echo "Conversion failed for $file"
  fi
done
